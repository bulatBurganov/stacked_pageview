import 'dart:developer';

import 'package:flutter/material.dart';

enum DragDirection { left, right, none }

class CardSwipeStack extends StatefulWidget {
  final StorySwiperWidgetBuilder widgetBuilder;
  final int itemCount;
  final int visiblePageCount;
  final double dx;
  final double dy;
  final double aspectRatio;
  final double depthFactor;
  final double paddingStart;
  final double verticalPadding;

  CardSwipeStack.builder({
    Key key,
    @required this.widgetBuilder,
    this.itemCount,
    this.visiblePageCount = 3,
    this.dx = 30,
    this.dy = 10,
    this.aspectRatio = 2 / 3,
    this.depthFactor = 0.2,
    this.paddingStart = 0,
    this.verticalPadding = 0,
  }) : super(key: key);

  @override
  _CardSwipeStackState createState() => _CardSwipeStackState();
}

class _CardSwipeStackState extends State<CardSwipeStack> {
  PageController _pageController;
  double _pagePosition = 0;
  List<Widget> _widgetList = [];
  DragDirection direction = DragDirection.none;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _pagePosition = _pageController.page;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: <Widget>[
        _getPages(),
        PageView.builder(
          physics: BouncingScrollPhysics(),
          controller: _pageController,
          itemCount: widget.itemCount,
          itemBuilder: (context, index) => Container(),
        ),
        Container(
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx < 0) {
                direction = DragDirection.left;
              } else
                direction = DragDirection.right;
            },
            onHorizontalDragEnd: (details) {
              switch (direction) {
                case DragDirection.left:
                  _pageController.animateToPage(
                      _pageController.page.toInt() + 1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease);
                  break;

                case DragDirection.right:
                  _pageController.animateToPage(
                      _pageController.page.toInt() - 1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease);
                  break;

                default:
              }

              isDragging = false;
              log('$isDragging');
            },
            child: _getPages(),
          ),
        )
      ]),
    );
  }

  Widget _getPages() {
    final List<Widget> pageList = [];
    final int currentPageIndex = _pagePosition.floor();
    final int lastPage = currentPageIndex + widget.visiblePageCount;
    final double width = MediaQuery.of(context).size.width;
    final double delta = _pagePosition - currentPageIndex;
    double top = -widget.dy * delta + widget.verticalPadding;
    double start = -widget.dx * delta + widget.paddingStart;
    pageList.add(_getWidgetForValues(
        top, -width * delta + widget.paddingStart, currentPageIndex));
    int i;
    int rIndex = 1;
    for (i = currentPageIndex + 1; i < lastPage; i++) {
      start += widget.dx;
      top += widget.dy;
      if (i >= widget.itemCount) continue;
      pageList.add(
          _getWidgetForValues(top, start * _getDepthFactor(rIndex, delta), i));
      rIndex++;
    }
    if (i < widget.itemCount) {
      start += widget.dx * delta;
      top += widget.dy;
      pageList.add(
          _getWidgetForValues(top, start * _getDepthFactor(rIndex, delta), i));
    }
    return Stack(children: pageList.reversed.toList());
  }

  double _getDepthFactor(int index, double delta) {
    return (1 - widget.depthFactor * (index - delta) / widget.visiblePageCount);
  }

  Widget _getWidgetForValues(double top, double start, int index) {
    Widget childWidget;
    if (index < _widgetList.length) {
      childWidget = _widgetList[index];
    } else {
      childWidget = widget.widgetBuilder(index);
      _widgetList.insert(index, childWidget);
    }
    return Positioned.directional(
      top: top,
      bottom: top,
      start: start,
      textDirection: TextDirection.ltr,
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: childWidget,
      ),
    );
  }
}

typedef Widget StorySwiperWidgetBuilder(int index);
