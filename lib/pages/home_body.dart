import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../tools/constants.dart';
import '../tools/user_tool.dart';
import '../tools/request_parser.dart';
import '../entries/subject.dart';
import '../entries/page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'subject_detail.dart';

class HomeBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeBodyState();
  }
}

class HomeBodyState extends State<HomeBody> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  RefreshController _refreshController;
  List<Subject> _newestSubjects = [];

//  bool _isPulling = false;
//  bool _isHandOff = false;
//  double _lastOffset = 0.0;
  int _pageNum = 1;
  int _maxPages = 1;

  void _handleRefresh(bool up) {
    if (up) {
      Future.delayed(const Duration(seconds: 2)).then((value) {
        _pageNum = 1;
        _newestSubjects.clear();
        _fetchData();
      });
    } else {
      Future.delayed(const Duration(seconds: 2)).then((value) {
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
    _refreshController = RefreshController();
    super.initState();

    _prefs.then((SharedPreferences prefs) {
      String loginUser = prefs.getString(Strings.PREFS_KEY_LOGIN_USER);
      if (loginUser != null && loginUser.isNotEmpty) {
        UserUtil.getInstance().loginUser =
            UserUtil.parseUser(json.decode(loginUser));
      }
    });

    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: _handleRefresh,
        onOffsetChange: _offsetCallback,
        child: ListView.builder(
            itemCount: _newestSubjects.length * 2 - 1,
            itemBuilder: (context, i) {
              if (i.isOdd) {
                return Divider(
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
    return ListTile(
        leading: SvgPicture.asset('assets/icons/place_holder.svg',
            width: 80.0, height: 60.0),
        title: Text(subject.title,
            style: TextStyle(color: Colors.black87, fontSize: 18.0)),
        subtitle: Text(subject.content,
            style: TextStyle(color: Colors.black54, fontSize: 14.0)),
        onTap: () {
          _showSubjectDetail(subject.id);
        });
  }

  void _fetchData() {
    RequestParser.getNewestSubjectList(_pageNum).then((pageSubjects) {
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
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SubjectDetailPage(subjectId);
    }));
  }
}
