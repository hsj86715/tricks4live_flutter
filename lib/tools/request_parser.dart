import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'constants.dart';
import '../entries/results.dart';
import '../entries/subject.dart';
import '../entries/user.dart';
import '../entries/page.dart';
import '../entries/label.dart';

typedef dynamic DataParser(Map<String, dynamic> dataJson);

class RequestParser {
  static final DIO = new Dio();

  static Future<dynamic> _request(String path, DataParser parser, String method,
      {params}) async {
    if (path == null) {
      return null;
    }
    if (!path.startsWith('/')) {
      path = '/$path';
    }

    //trust personal https key
    DIO.onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    };

    Response<dynamic> response;
    if (method.toLowerCase() == 'get') {
      response = await DIO.get(Strings.HOST_URL + path, data: params);
    } else {
      response = await DIO.post(Strings.HOST_URL + path, data: params);
    }
    if (response.statusCode == 200) {
      Map<String, dynamic> resultJson = response.data;
      if (resultJson['code'] == 200 &&
          resultJson.containsKey('data') &&
          parser != null) {
        //服务器下发json的data字段
        return parser(resultJson['data']);
      } else {
        Result result = new Result();
        result.code = resultJson['code'];
        result.status = resultJson['status'];
        result.msg = resultJson['msg'];
        return result;
      }
    } else {
      Result result = new Result();
      result.code = response.statusCode;
      result.status = 'Fail';
      result.msg = 'Http request error';
      return result;
    }
  }

  static Future<dynamic> _postRequest(String path, DataParser parser,
      {params}) async {
    return _request(path, parser, 'post', params: params);
  }

  static Future<dynamic> _getRequest(String path, DataParser parser,
      {params}) async {
    return _request(path, parser, 'get', params: params);
  }

  ///return [Page] with generics[Subject] on success, else [Result].
  static Future<dynamic> getNewestSubjectList(String path, {params}) async {
    return _getRequest(path, _parseSubjectList, params: params);
  }

  ///return [User] on success, else [Result].
  static Future<dynamic> registerUser(String path, {params}) async {
    return _postRequest(path, _parseUser, params: params);
  }

  ///return [User] on success, else [Result].
  static Future<dynamic> loginUser(String path, {params}) async {
    return _postRequest(path, _parseUser, params: params);
  }

  ///return [Subject] on success, else [Result].
  static Future<dynamic> getSubjectDetail(String path, {params}) async {
    return _getRequest(path, _parseSubject, params: params);
  }

  ///return [Page] with generics[Comment] on success, else [Result].
  static Future<dynamic> getSubjectComments(String path, {params}) async {
    return _getRequest(path, _parseCommentList, params: params);
  }

  static Page<Comment> _parseCommentList(Map<String, dynamic> commentPageJson) {
    Page<Comment> pagedComment = __packagePage<Comment>(commentPageJson);

    List<dynamic> commentResults = commentPageJson['contentResults'];
    List<Comment> comments = new List<Comment>();

    commentResults.forEach((commentJson) {
      comments.add(__parseComment(commentJson));
    });
    pagedComment.contentResults = comments;
    return pagedComment;
  }

  static User _parseUser(Map<String, dynamic> userJson) {
    User user = new User();
    user.id = userJson['id'];
    user.userName = userJson['userName'];
    user.nickName = userJson['nickName'];
    user.email = userJson['email'];
    user.phone = userJson['phone'];
    user.address = userJson['address'];
    user.token = userJson['token'];
    user.avatar = userJson['avatar'];
    user.permission = userJson['permission'];
    return user;
  }

  static Page<Subject> _parseSubjectList(Map<String, dynamic> subjectPageJson) {
    Page<Subject> pagedSubject = __packagePage<Subject>(subjectPageJson);

    List<dynamic> subjectResults = subjectPageJson['contentResults'];
    List<Subject> subjects = new List<Subject>();

    subjectResults.forEach((dynamic subjectJson) {
      subjects.add(__parseBaseSubject(subjectJson));
    });
    pagedSubject.contentResults = subjects;
    return pagedSubject;
  }

  static Subject _parseSubject(Map<String, dynamic> subjectJson) {
    Subject subject = __parseBaseSubject(subjectJson);

    subject.videoUrl = subjectJson['videoUrl'];
    subject.createDate = DateTime.parse(subjectJson['createDate']);
    subject.updateDate = DateTime.parse(subjectJson['updateDate']);
    var catJson = subjectJson['category'];
    if (catJson != null) {
      CategorySimple category = new CategorySimple(
          catJson['nameCN'], catJson['nameEN'],
          id: catJson['id']);
      subject.category = category;
    }

    var subSteps = subjectJson['operateSteps'];
    if (subSteps != null) {
      subSteps = json.decode(subSteps);
      subject.operateSteps = new List<Steps>();
      subSteps.forEach((stepMap) {
        subject.operateSteps.add(new Steps(stepMap['operation'],
            picture: stepMap['picture'], timeCosts: stepMap['timeCosts']));
      });
    }

    var subLabels = subjectJson['labels'];
    if (subLabels != null) {
      subject.labels = new List<Label>();
      subLabels.forEach((labelMap) {
        Label label = new Label(labelMap['nameCN'], labelMap['nameEN']);
        label.id = labelMap['id'];
        subject.labels.add(label);
      });
    }
    return subject;
  }

  static Subject __parseBaseSubject(Map<String, dynamic> subjectJson) {
    Subject subject = new Subject();
    subject.id = subjectJson['id'];
    subject.title = subjectJson['title'];
    subject.coverPicture = subjectJson['coverPicture'];
    subject.content = subjectJson['content'];
    subject.contentType = subjectJson['contentType'];
    subject.validCount = subjectJson['validCount'];
    subject.invalidCount = subjectJson['invalidCount'];

    var userJson = subjectJson['user'];
    UserSimple userSimple = new UserSimple();
    userSimple.id = userJson['id'];
    userSimple.nickName = userJson['nickName'];
    userSimple.avatar = userJson['avatar'];
    subject.user = userSimple;
    return subject;
  }

  static Page<T> __packagePage<T>(Map<String, dynamic> pageJson) {
    Page<T> page = new Page<T>();
    page.pageNum = pageJson['pageNum'];
    page.pageSize = pageJson['pageSize'];
    page.totalCount = pageJson['totalCount'];
    return page;
  }

  static Comment __parseComment(Map<String, dynamic> commentJson) {
    Comment comment = new Comment();
    comment.id = commentJson['id'];
    comment.content = commentJson['content'];
    comment.createDate = DateTime.parse(commentJson['createDate']);
    comment.subjectId = commentJson['subjectId'];
    comment.floor = commentJson['floor'];
    comment.deleted = commentJson['deleted'];
    comment.agreeCount = commentJson['agreeCount'];
    comment.superId = commentJson['superId'];
    var followJson = commentJson['follow'];
    if (followJson != null) {
      print('followJson.runtimeType: ${followJson.runtimeType}');
      if (followJson is String) {
        followJson = json.encode(followJson);
      }
      comment.follow = __parseComment(followJson);
    }
    return comment;
  }
}
