import 'dart:developer';

import 'package:flutter/material.dart';

enum DragDirection { left, right, none }

class FinalCardStacl extends StatefulWidget {
  final StorySwiperWidgetBuilder widgetBuilder;
  final int itemCount;
  final int visiblePageCount;
  final double dy;
  final double aspectRatio;
  final double depthFactor;
  final double paddingStart;
  final double verticalPadding;
  final double cardHeight;
  final double cardWidth;

  FinalCardStacl.builder(
      {Key key,
      @required this.widgetBuilder,
      this.itemCount,
      this.visiblePageCount = 4,
      this.dy = -10,
      this.aspectRatio = 2 / 3,
      this.depthFactor = 0.2,
      this.paddingStart = 0,
      this.verticalPadding = 32,
      this.cardHeight,
      this.cardWidth})
      : super(key: key);

  @override
  _CardSwipeStackState createState() => _CardSwipeStackState();
}

class _CardSwipeStackState extends State<FinalCardStacl> {
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
        PageView.builder(
          physics: BouncingScrollPhysics(),
          controller: _pageController,
          itemCount: widget.itemCount,
          itemBuilder: (context, index) => null,
        ),
        Center(
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
    double cardWidth = widget.cardWidth;
    double cardHeight = widget.cardHeight;
    final List<Widget> pageList = [];
    final int currentPageIndex = _pagePosition.floor();
    final int lastPage = currentPageIndex + widget.visiblePageCount;
    final double width = MediaQuery.of(context).size.width;
    final double delta = _pagePosition - currentPageIndex;
    double startPadding = (MediaQuery.of(context).size.width - cardWidth) / 2;
    double top = -widget.dy * delta + widget.verticalPadding;
    double start = (MediaQuery.of(context).size.width - cardWidth) / 2;

    log('delta=$delta');
    pageList.add(_getWidgetForValues(top, -width * delta + startPadding,
        cardWidth + delta * 10, cardHeight, currentPageIndex));

    int i;
    int rIndex = 1;
    for (i = currentPageIndex + 1; i < lastPage; i++) {
      start += 5;
      cardHeight -= 10;
      cardWidth -= 10;
      top += widget.dy;
      if (i >= widget.itemCount) continue;
      pageList.add(_getWidgetForValues(top, start - (delta * 5),
          cardWidth + (delta * 10), cardHeight + (delta * 10), i));
      rIndex++;
    }
    if (i < widget.itemCount) {
      top += widget.dy;
      pageList.add(_getWidgetForValues(
          top, start * _getDepthFactor(rIndex, delta), 0, 0, i));
    }
    return Stack(
        alignment: Alignment.center, children: pageList.reversed.toList());
  }

  double _getDepthFactor(int index, double delta) {
    return (1 - widget.depthFactor * (index - delta) / widget.visiblePageCount);
  }

  Widget _getWidgetForValues(
      double top, double start, double width, double height, int index) {
    Widget childWidget;
    if (index < _widgetList.length) {
      childWidget = _widgetList[index];
    } else {
      childWidget = widget.widgetBuilder(index);
      _widgetList.insert(index, childWidget);
    }
    return Positioned.directional(
      top: top,
      start: start,
      textDirection: TextDirection.ltr,
      child: Container(
        width: width,
        height: height,
        child: childWidget,
      ),
    );
  }
}

typedef Widget StorySwiperWidgetBuilder(int index);
