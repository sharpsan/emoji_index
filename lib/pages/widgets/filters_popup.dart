import 'package:flutter/material.dart';

class FiltersPopup extends StatefulWidget {
  const FiltersPopup({
    super.key,
    required this.groupsWithSubgroups,
    this.initialGroup,
    this.initialSubGroup,
    this.onGroupSelected,
    this.onSubGroupSelected,
  });
  final Map<String, Set<String>> groupsWithSubgroups;
  final String? initialGroup;
  final String? initialSubGroup;
  final void Function(String group)? onGroupSelected;
  final void Function(String group, String subGroup)? onSubGroupSelected;

  @override
  State<FiltersPopup> createState() => _FiltersPopupState();
}

class _FiltersPopupState extends State<FiltersPopup> {
  /// options / filters
  late String? _selectedGroup = widget.initialGroup;
  late String? _selectedSubGroup = widget.initialSubGroup;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      trackVisibility: true,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          width: double.maxFinite,
          child: Column(
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: widget.groupsWithSubgroups.keys
                    .map(
                      (group) => ChoiceChip(
                        // selectedColor: Colors.red,
                        label: Text(group),
                        selected: _selectedGroup == group,
                        onSelected: (selected) {
                          if (selected) {
                            widget.onGroupSelected?.call(group);
                            setState(() {
                              _selectedGroup = group;
                              _selectedSubGroup = null;
                            });
                          }
                        },
                      ),
                    )
                    .toList(),
              ),
              if (_selectedGroup != null) ...[
                const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Align(
                    child: Text(
                      'Subgroup',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: widget.groupsWithSubgroups[_selectedGroup]!
                      .map(
                        (subGroup) => ChoiceChip(
                          // selectedColor: Colors.red,
                          label: Text(subGroup),
                          selected: _selectedSubGroup == subGroup,
                          onSelected: (selected) {
                            if (selected) {
                              widget.onSubGroupSelected?.call(
                                _selectedGroup!,
                                subGroup,
                              );
                              setState(() {
                                _selectedSubGroup = subGroup;
                              });
                            }
                          },
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
