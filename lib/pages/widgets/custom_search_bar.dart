import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    super.key,
    this.searchController,
    this.onClearButtonPressed,
    this.onFilterButtonPressed,
    this.onChanged,
  });
  final TextEditingController? searchController;
  final void Function()? onClearButtonPressed;
  final void Function()? onFilterButtonPressed;
  final void Function(String query)? onChanged;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _searchController;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _searchController = widget.searchController ?? TextEditingController();
    _searchController.addListener(() => _maybeToggleClearButton());
  }

  @override
  void didUpdateWidget(covariant CustomSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchController != widget.searchController) {
      _searchController.removeListener(() => _maybeToggleClearButton());
      _searchController = widget.searchController ?? TextEditingController();
      _searchController.addListener(() => _maybeToggleClearButton());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search emoji',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// clear button
              if (_showClearButton)
                IconButton(
                  onPressed: () {
                    _searchController.clear();
                    widget.onClearButtonPressed?.call();
                  },
                  icon: const Icon(Icons.clear),
                ),

              /// filter button
              IconButton(
                onPressed: widget.onFilterButtonPressed,
                icon: const Icon(Icons.filter_list),
              ),
            ],
          ),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }

  void _maybeToggleClearButton() {
    if (_searchController.text.isEmpty && _showClearButton) {
      _showClearButton = false;
      setState(() {});
    } else if (_searchController.text.isNotEmpty && !_showClearButton) {
      _showClearButton = true;
      setState(() {});
    }
  }
}
