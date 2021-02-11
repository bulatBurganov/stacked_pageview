import 'package:flutter/material.dart';

class StackOfCards extends StatefulWidget {
  final double width;
  final double height;
  final double cardSpacing;
  final int itemCount;
  final double borderRadius;
  final CardBuilder cardbuilder;
  final int visiblePageCount;

  StackOfCards({
    @required this.cardbuilder,
    @required this.itemCount,
    @required this.width,
    @required this.height,
    this.borderRadius = 5,
    this.visiblePageCount = 3,
    this.cardSpacing = 20.0,
  });
  @override
  _StackOfCardsState createState() => _StackOfCardsState();
}

class _StackOfCardsState extends State<StackOfCards> {
  PageController _pageController = PageController();
  double _pagePosition = 0;
  List<Widget> _widgetList = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildStack(),
        PageView.builder(
            physics: BouncingScrollPhysics(),
            controller: _pageController,
            itemCount: widget.itemCount,
            itemBuilder: (context, index) => Container()),
      ],
    );
  }

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

  Widget buildStack() {
    final List<Widget> pageList = [];
    final int currentPageIndex = _pagePosition.floor();
    final int lastPage = currentPageIndex + widget.visiblePageCount;
    final double width = MediaQuery.of(context).size.width;
    final double delta = _pagePosition - currentPageIndex;
    double top = -widget.cardSpacing * delta;
    double start = -widget.cardSpacing * delta;
    pageList.add(buildCard(top, -width * delta, currentPageIndex));
    int i;
    int rIndex = 1;
    for (i = currentPageIndex + 1; i < lastPage; i++) {
      start += widget.cardSpacing;
      top += widget.cardSpacing;
      if (i >= widget.itemCount) continue;
      pageList.add(buildCard(top, start * _getDepthFactor(rIndex, delta), i));
      rIndex++;
    }
    if (i < widget.itemCount) {
      start += widget.cardSpacing * delta;
      top += widget.cardSpacing;
      pageList.add(buildCard(top, start * _getDepthFactor(rIndex, delta), i));
    }
    return Stack(children: pageList.reversed.toList());
  }

  double _getDepthFactor(int index, double delta) {
    return (1 - 0.2 * (index - delta) / widget.visiblePageCount);
  }

  Widget buildCard(double top, double start, int index) {
    // log('$top $index');
    Widget childWidget;
    if (index < _widgetList.length) {
      childWidget = _widgetList[index];
    } else {
      childWidget = widget.cardbuilder(index);
      _widgetList.insert(index, childWidget);
    }
    return Positioned(
      top: top,
      bottom: top,
      child: childWidget,
    );
  }
}

typedef Widget CardBuilder(int index);
