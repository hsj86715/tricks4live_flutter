import 'dart:async';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../tools/request_parser.dart';

class HomeBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeBodyState();
  }
}

class HomeBodyState extends State<HomeBody> {
  static List<WordPair> _items = new List();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    completer.complete(null);
    return completer.future.then((_) {
      _items.clear();
      _items.addAll(generateWordPairs().take(20));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
        child: new FutureBuilder(
            future: RequestParser.getNewestSubjectList("/subject/findNewest",
                params: {'page_num': 1, 'page_size': 5}),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return new Center(child: new Text('Loading...'));
                default:
                  if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return new Text('Error: ${snapshot.error}');
                  } else {
                    return new Text('Result: ${snapshot.data}');
                  }
              }
            }),
        onRefresh: _handleRefresh);
  }
}
