import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'constants.dart';
import '../entries/results.dart';
import '../entries/subject.dart';
import '../entries/user.dart';
import '../entries/page.dart';

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
}
