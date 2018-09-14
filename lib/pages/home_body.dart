import 'dart:async';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../tools/request_parser.dart';
import '../entries/subject.dart';
import '../entries/page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../entries/results.dart';
import 'subject_detail.dart';

class HomeBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeBodyState();
  }
}

class HomeBodyState extends State<HomeBody> {
  RefreshController _refreshController;
  List<Subject> _newestSubjects = [];

//  bool _isPulling = false;
//  bool _isHandOff = false;
//  double _lastOffset = 0.0;
  int _pageNum = 1;
  int _maxPages = 1;

  void _handleRefresh(bool up) {
    if (up) {
      new Future.delayed(const Duration(seconds: 2)).then((value) {
        _pageNum = 1;
        _newestSubjects.clear();
        _fetchData();
      });
    } else {
      new Future.delayed(const Duration(seconds: 2)).then((value) {
        _fetchData();
      });
    }
  }

  void _offsetCallback(bool up, double offset) {
    print('Is up?$up, offset: $offset');
//    if (offset > _lastOffset) {
//      _isPulling = true;
//      _isHandOff = false;
//      _lastOffset = offset;
//    } else if (_lastOffset > offset) {
//      _isPulling = false;
//      _isHandOff = true;
//      _lastOffset
//    }
  }

  @override
  void initState() {
    _refreshController = new RefreshController();
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return new SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: _handleRefresh,
        onOffsetChange: _offsetCallback,
        child: new ListView.builder(
            itemCount: _newestSubjects.length * 2 - 1,
            itemBuilder: (context, i) {
              if (i.isOdd) {
                return new Divider(
                  height: 1.0,
                  color: Colors.black54,
                );
              }
              final index = i ~/ 2;
//              if (i >= _newestSubjects.length - 2) {
//                _fetchData();
//              }
              return _buildItem(_newestSubjects[index]);
            }));
  }

  Widget _buildItem(Subject subject) {
    print(subject.toString());
    return new ListTile(
      leading: new SvgPicture.asset('assets/icons/place_holder.svg',
          width: 80.0, height: 60.0),
      title: new Text(
        subject.title,
        style: new TextStyle(color: Colors.black87, fontSize: 18.0),
      ),
      subtitle: new Text(
        subject.content,
        style: new TextStyle(color: Colors.black54, fontSize: 14.0),
      ),
      onTap: () {
        _showSubjectDetail(subject.id);
      },
    );
  }

  void _fetchData() {
    RequestParser.getNewestSubjectList("/subject/findNewest",
        params: {'page_num': _pageNum, 'page_size': 10}).then((pageSubjects) {
      if (pageSubjects is Page<Subject>) {
        _maxPages = pageSubjects.getTotalPages();
        _newestSubjects.addAll(pageSubjects.contentResults);
        if (_pageNum < _maxPages) {
          _refreshController.sendBack(false, RefreshStatus.idle);
          _pageNum++;
        } else {
          _refreshController.sendBack(false, RefreshStatus.completed);
        }
        setState(() {});
      } else {
        _refreshController.sendBack(false, RefreshStatus.failed);
      }
    }).catchError(() {
      _refreshController.sendBack(false, RefreshStatus.failed);
    });
  }

  void _showSubjectDetail(int subjectId) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new SubjectDetailPage(subjectId);
    }));
  }
}
