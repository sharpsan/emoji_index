import 'package:emoji_index/models/emoji.dart';
import 'package:emoji_index/pages/widgets/custom_search_bar.dart';
import 'package:emoji_index/pages/widgets/filters_popup.dart';
import 'package:emoji_index/utils/debouncer.dart';
import 'package:emoji_index/utils/emojis.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _iconSize = 48.0;

class EmojisListPage extends StatefulWidget {
  const EmojisListPage({super.key});

  @override
  State<EmojisListPage> createState() => _EmojisListPageState();
}

class _EmojisListPageState extends State<EmojisListPage> {
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 300));

  /// emojis data
  final _emojis = Emojis();
  final List<Emoji> _emojisFiltered = [];
  final _searchController = TextEditingController();

  String? _selectedGroup;
  String? _selectedSubGroup;

  @override
  void initState() {
    super.initState();

    /// load emojis
    _emojis.ready().whenComplete(() {
      setState(() {
        _emojisFiltered.addAll(_emojis.emojis);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emoji Index'),
      ),
      body: Column(
        children: [
          /// search bar
          CustomSearchBar(
            searchController: _searchController,
            onClearButtonPressed: _clearSearch,
            onFilterButtonPressed: () {
              /// show bottom sheet with filter options
              showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                  ),
                  builder: (context) {
                    return FiltersPopup(
                      groupsWithSubgroups: _emojis.groupsWithSubgroups,
                      initialGroup: _selectedGroup,
                      initialSubGroup: _selectedSubGroup,
                      onGroupSelected: _filterByGroup,
                      onSubGroupSelected: _filterByGroupAndSubgroup,
                    );
                  });
            },
            onChanged: (query) {
              _debouncer.run(() => _search(query));
            },
          ),

          /// selected group/subgroup
          if (_selectedGroup != null || _selectedSubGroup != null) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  if (_selectedGroup != null)
                    Chip(
                      label: Text(_selectedGroup!),
                      onDeleted: () {
                        _clearGroupSearch();
                      },
                    ),
                  if (_selectedSubGroup != null)
                    Chip(
                      label: Text(_selectedSubGroup!),
                      onDeleted: () {
                        _clearSubgroupSearch();
                      },
                    ),
                ],
              ),
            ),
          ],

          /// emojis list
          Expanded(
            child: FutureBuilder(
              future: _emojis.ready(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (_emojisFiltered.isEmpty) {
                  return const Center(child: Text('No emojis found'));
                }

                return ListView.builder(
                  itemCount: _emojisFiltered.length,
                  itemBuilder: (context, index) {
                    final emoji = _emojisFiltered[index];
                    return ListTile(
                      leading: SizedBox(
                        height: _iconSize,
                        width: _iconSize,
                        child: Center(
                          child: Text(
                            emoji.emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      title: Text(emoji.name),
                      subtitle: Text('${emoji.group} - ${emoji.subGroup}'),
                      onTap: () {
                        /// hide current snackbar
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                        /// copy emoji to clipboard
                        Clipboard.setData(ClipboardData(text: emoji.emoji));

                        /// show snackbar message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Copied ${emoji.emoji} to clipboard'),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debouncer.cancel();
    super.dispose();
  }

  void _filterByGroup(String group) {
    /// filter emojis by group
    _emojisFiltered.clear();
    for (final emoji in _emojis.emojis) {
      if (emoji.group == group) {
        _emojisFiltered.add(emoji);
      }
    }
    setState(() {
      _selectedGroup = group;
      _selectedSubGroup = null;
    });
  }

  void _filterByGroupAndSubgroup(String group, String subGroup) {
    /// filter emojis by group and sub-group
    _emojisFiltered.clear();
    for (final emoji in _emojis.emojis) {
      if (emoji.group == group && emoji.subGroup == subGroup) {
        _emojisFiltered.add(emoji);
      }
    }
    setState(() {
      _selectedGroup = group;
      _selectedSubGroup = subGroup;
    });
  }

  void _clearGroupSearch() {
    _emojisFiltered.clear();
    _emojisFiltered.addAll(_emojis.emojis);
    setState(() {
      _selectedGroup = null;
      _selectedSubGroup = null;
    });
  }

  void _clearSubgroupSearch() {
    _filterByGroup(_selectedGroup!);
  }

  void _search(String query) {
    _emojisFiltered.clear();
    for (final emoji in _emojis.emojis) {
      if (emoji.contains(query) &&
          (emoji.group == _selectedGroup || _selectedGroup == null) &&
          (emoji.subGroup == _selectedSubGroup || _selectedSubGroup == null)) {
        _emojisFiltered.add(emoji);
      }
    }

    setState(() {
      /// Update the UI with the filtered emojis
    });
  }

  void _clearSearch() {
    _emojisFiltered.clear();
    _emojisFiltered.addAll(_emojis.emojis);
    setState(() {});
  }
}
