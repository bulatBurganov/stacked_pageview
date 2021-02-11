import 'dart:developer';

import 'package:cards_stack/final_card_stack.dart';
import 'package:cards_stack/flutter_card_stack/flutter_stack_card.dart';
import 'package:cards_stack/my_stack/stack_card_test.dart';
import 'package:flutter/material.dart';

import 'card_stack.dart';
import 'flutter_card_stack/src/flutter_stack_card.dart';

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
        body: Center(
          child: Container(
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
            ),
          ),
        ));
  }
}
