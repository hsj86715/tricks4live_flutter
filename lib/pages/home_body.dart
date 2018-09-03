import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import '../tools/constants.dart';
import '../entries/subject.dart';
import '../entries/user.dart';
import '../entries/page.dart';

class HomeBody extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;

  HomeBody(this.scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return new HomeBodyState(scaffoldKey);
  }
}

class HomeBodyState extends State<HomeBody> {
  GlobalKey<ScaffoldState> scaffoldKey;
  static List<WordPair> _items = new List();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  HomeBodyState(this.scaffoldKey);

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    completer.complete(null);
    return completer.future.then((_) {
      _items.clear();
      _items.addAll(generateWordPairs().take(20));
      setState(() {});
//      scaffoldKey.currentState?.showSnackBar(new SnackBar(
//          content: const Text('Refresh complete'),
//          action: new SnackBarAction(
//              label: 'RETRY',
//              onPressed: () {
//                _refreshIndicatorKey.currentState.show();
//              })));
    });
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
        child: new FutureBuilder(
            future: _getSubject(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return new Center(child: new Text('Loading...'));
                default:
                  if (snapshot.hasError) {
                    return new Text('Error: ${snapshot.error}');
                  } else {
                    return new Text('Result: ${snapshot.data}');
                  }
              }
            }),
        onRefresh: _handleRefresh);
  }

  Future<Page<Subject>> _getSubject() async {
    Dio dio = new Dio();
    Response<dynamic> response = await dio.get(
        Strings.HOST_URL + '/subject/findNewest',
        data: {'page_num': 1, 'page_size': 5});
    if (response.statusCode == 200 && response.data['code'] == 200) {
      Map<String, dynamic> subjectPageJson = response.data['data'];
      Page<Subject> pagedSubject = new Page();
      pagedSubject.pageNum = subjectPageJson['pageNum'];
      pagedSubject.pageSize = subjectPageJson['pageSize'];
      pagedSubject.totalCount = subjectPageJson['totalCount'];

      List<dynamic> subjectResult = subjectPageJson['contentResults'];
      List<Subject> subjects = new List<Subject>();
      print(subjectResult is List);
      subjectResult.forEach((dynamic map) {
        print(map.toString());
        Subject subject = new Subject();
        subject.id = map['id'];
        subject.createDate = DateTime.parse(map['createDate']);
        subject.categoryId = map['categoryId'];
        subject.title = map['title'];
        subject.content = map['content'];
        subject.contentType = map['contentType'];
        subject.videoUrl = map['videoUrl'];
        subject.validCount = map['validCount'];
        subject.invalidCount = map['invalidCount'];

        List<dynamic> subPics = map['picUrls'];
        subject.picUrls = new List<String>();
        subPics.forEach((dynamic picUrl) {
          subject.picUrls.add(picUrl);
        });

        var userJson = map['user'];
        UserSimple userSimple = new UserSimple();
        userSimple.id = userJson['id'];
        userSimple.nickName = userJson['nickName'];
        userSimple.avatar = userJson['avatar'];
        subject.user = userSimple;

        subjects.add(subject);
      });
      pagedSubject.contentResults = subjects;
      return pagedSubject;
    }
    return null;
  }
}
