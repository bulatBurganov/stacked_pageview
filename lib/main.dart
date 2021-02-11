import 'dart:developer';

import 'package:cards_stack/final_card_stack.dart';
import 'package:cards_stack/flutter_card_stack/flutter_stack_card.dart';
import 'package:flutter/material.dart';

import 'card_stack.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StorySwiper Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _pageController = PageController();
  final List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("StorySwiper Example"),
        ),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.6 + 36,
              child: FinalCardStacl.builder(
                itemCount: 5,
                aspectRatio: 2 / 3,
                depthFactor: 0.3,
                cardWidth: MediaQuery.of(context).size.width * 0.9,
                cardHeight: MediaQuery.of(context).size.height * 0.6,
                visiblePageCount: 3,
                widgetBuilder: (index) {
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors[index],
                      ),
                      child: Column(
                        children: [
                          RaisedButton(
                            child: Text('$index'),
                            onPressed: () => log('pressed'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                pageController: _pageController,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                    onPressed: () => _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease)),
                RaisedButton(onPressed: () {
                  // _pageController.nextPage(
                  //     duration: Duration(milliseconds: 300),
                  //     curve: Curves.ease);
                  _pageController.animateToPage(0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease);
                })
              ],
            )
          ],
        ));
  }
}
