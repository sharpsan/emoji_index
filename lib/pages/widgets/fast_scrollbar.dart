import 'package:flutter/material.dart';

class FastScroll extends StatefulWidget {
  final ScrollController controller;
  final List<String> groups;

  FastScroll({required this.controller, required this.groups});

  @override
  _FastScrollState createState() => _FastScrollState();
}

class _FastScrollState extends State<FastScroll> {
  late double _thumbTop = 0;
  late String _currentGroup = '';

  void _updateScrollPosition(double thumbTop) {
    final scrollPosition = thumbTop /
        context.size!.height *
        widget.controller.position.maxScrollExtent;
    widget.controller.jumpTo(scrollPosition);
  }

  void _updateCurrentGroup(double thumbTop) {
    final index =
        (thumbTop / context.size!.height * widget.groups.length).floor();
    setState(() {
      _currentGroup = widget.groups[index];
    });
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _thumbTop += details.delta.dy;
      _thumbTop = _thumbTop.clamp(0.0, context.size!.height - 50);
    });
    _updateScrollPosition(_thumbTop);
    _updateCurrentGroup(_thumbTop);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: _thumbTop,
          right: 0,
          child: GestureDetector(
            onVerticalDragUpdate: _onVerticalDragUpdate,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _currentGroup,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
