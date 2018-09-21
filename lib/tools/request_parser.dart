import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'constants.dart';
import '../entries/results.dart';
import '../entries/subject.dart';
import '../entries/user.dart';
import '../entries/page.dart';
import '../entries/label.dart';
import 'user_tool.dart';

typedef dynamic DataParser(Map<String, dynamic> dataJson);

typedef List<dynamic> ListDataParser(List<dynamic> dataJson);

class RequestParser {
  static final DIO = new Dio();

  static Future<dynamic> _request(String path, String method,
      {DataParser parser, ListDataParser listParser, params}) async {
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
    } else if (method.toLowerCase() == 'post') {
      response = await DIO.post(Strings.HOST_URL + path, data: params);
    }
    if (response.statusCode == 200) {
      Map<String, dynamic> resultJson = response.data;
      if (resultJson['code'] == 200 &&
          resultJson.containsKey('data') &&
          (parser != null || listParser != null)) {
        //服务器下发json的data字段
        var resultData = resultJson['data'];
        if (resultData is List) {
          return listParser(resultData);
        } else {
          return parser(resultData);
        }
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

  static Future<dynamic> _postRequest(String path,
      {DataParser parser, ListDataParser listParser, params}) async {
    return _request(path, 'post',
        parser: parser, listParser: listParser, params: params);
  }

  static Future<dynamic> _getRequest(String path,
      {DataParser parser, ListDataParser listParser, params}) async {
    return _request(path, 'get',
        parser: parser, listParser: listParser, params: params);
  }

  ///return [Page] with generics[Subject] on success, else [Result].
  static Future<dynamic> getNewestSubjectList(int pageNum,
      {int pageSize = 10}) async {
    assert(pageNum != null && pageNum >= 1);
    return _getRequest("/subject/findNewest",
        parser: _parsePageSubjects,
        params: {'page_num': pageNum, 'page_size': pageSize});
  }

  ///return [User] on success, else [Result].
  static Future<dynamic> registerUser(User user) async {
    assert(user != null);
    return _postRequest('/user/register',
        parser: UserUtil.parseUser, params: json.encode(user));
  }

  ///return [User] on success, else [Result].
  static Future<dynamic> loginUser(User user) async {
    assert(user != null && user.userName != null && user.password != null);
    return _postRequest('/user/login',
        parser: UserUtil.parseUser, params: json.encode(user));
  }

  ///return [Subject] on success, else [Result].
  static Future<dynamic> getSubjectDetail(int subjectId, {int userId}) async {
    assert(subjectId != null && subjectId >= 0);
    var param;
    if (userId == null) {
      param = {'subject_id': subjectId};
    } else {
      param = {'subject_id': subjectId, 'user_id': userId};
    }
    return _getRequest("/subject/findById",
        parser: _parseSubject, params: param);
  }

  ///return [Page] with generics[Comment] on success, else [Result].
  static Future<dynamic> getSubjectComments(
      {@required int subjectId,
      @required int pageNum,
      int pageSize = 10}) async {
    assert(subjectId != null && subjectId >= 0);
    assert(pageNum != null && pageNum >= 1);
    return _getRequest('/comment/findByPage',
        parser: _parsePageComments,
        params: {
          'subject_id': subjectId,
          'page_num': pageNum,
          'page_size': pageSize
        });
  }

  ///return [List] with generics[Label] on success, else [Result].
  static Future<dynamic> getHottestComments(
      {@required int subjectId, int size = 5}) async {
    assert(subjectId != null && subjectId >= 0);
    return _getRequest('/comment/findHottest',
        listParser: _parseCommentList,
        params: {'subject_id': subjectId, 'size': size});
  }

  ///return [List] with generics[Label] on success, else [Result].
  static Future<dynamic> getAllLabels() async {
    return _getRequest('/label/findAll', listParser: _parseAllLabels);
  }

  ///return [Result]
  static Future<dynamic> addLabel(
      {@required String nameCN, @required String nameEN}) async {
    assert(nameCN != null);
    assert(nameEN != null);
    return _postRequest('/label/add',
        params: {'name_cn': nameCN, 'name_en': nameEN});
  }

  ///return [Result]
  static Future<dynamic> collectSubject(bool collected,
      {@required int subjectId, @required int userId}) async {
    assert(subjectId != null && subjectId >= 0);
    assert(userId != null && userId >= 0);
    return _getRequest('/subject/collect', params: {
      'subject_id': subjectId,
      'user_id': userId,
      'collected': collected
    });
  }

  ///return [Result]
  static Future<dynamic> focusUser(bool focused,
      {@required int whichUser, @required int focusWho}) async {
    assert(whichUser != null && whichUser >= 0);
    assert(focusWho != null && focusWho >= 0);
    assert(whichUser != focusWho);
    return _getRequest('/user/focus', params: {
      'which_user': whichUser,
      'focus_who': focusWho,
      'focused': focused
    });
  }

  ///return [Result]
  static Future<dynamic> validateSubject(bool validated,
      {@required int subjectId, @required int userId}) async {
    assert(subjectId != null && subjectId >= 0);
    assert(userId != null && userId >= 0);
    return _getRequest('/subject/validate', params: {
      'subject_id': subjectId,
      'user_id': userId,
      'validated': validated
    });
  }

  ///return [Result]
  static Future<dynamic> invalidateSubject(bool invalidated,
      {@required int subjectId, @required int userId}) async {
    assert(subjectId != null && subjectId >= 0);
    assert(userId != null && userId >= 0);
    return _getRequest('/subject/invalidate', params: {
      'subject_id': subjectId,
      'user_id': userId,
      'invalidated': invalidated
    });
  }

  ///return [Result]
  static Future<dynamic> loginOut(String token) async {
    return _postRequest('/user/loginOut', params: {'user_token': token});
  }

  static List<Label> _parseAllLabels(List<dynamic> allLabelsJson) {
    List<Label> allLabels = new List();
    allLabelsJson.forEach((labelJson) {
      Label label = new Label(labelJson['nameCN'], labelJson['nameEN']);
      label.id = labelJson['id'];
      allLabels.add(label);
    });
    return allLabels;
  }

  static Page<Comment> _parsePageComments(
      Map<String, dynamic> commentPageJson) {
    Page<Comment> pagedComment = __packagePage<Comment>(commentPageJson);

    List<dynamic> commentResults = commentPageJson['contentResults'];
//    List<Comment> comments = new List<Comment>();
//
//    commentResults.forEach((commentJson) {
//      comments.add(__parseComment(commentJson));
//    });
    pagedComment.contentResults = _parseCommentList(commentResults);
    return pagedComment;
  }

  static List<Comment> _parseCommentList(List<dynamic> commentResults) {
    List<Comment> comments = new List<Comment>();

    commentResults.forEach((commentJson) {
      comments.add(__parseComment(commentJson));
    });
    return comments;
  }

  static Page<Subject> _parsePageSubjects(
      Map<String, dynamic> subjectPageJson) {
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

    subject.isCollected = subjectJson['collected'];
    subject.isFocused = subjectJson['focused'];
    subject.isInvalidated = subjectJson['invalidated'];
    subject.isValidated = subjectJson['validated'];
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
        Steps steps = new Steps();
        steps.operation = stepMap['operation'];
        steps.picture = stepMap['picture'];
        steps.timeCosts = stepMap['timeCosts'];
        subject.operateSteps.add(steps);
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

    subject.user = __parseUserSimple(subjectJson['user']);
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

    comment.commenter = __parseUserSimple(commentJson['user']);

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

  static UserSimple __parseUserSimple(Map<String, dynamic> userJson) {
    UserSimple userSimple = new UserSimple();
    userSimple.id = userJson['id'];
    userSimple.nickName = userJson['nickName'];
    userSimple.avatar = userJson['avatar'];
    return userSimple;
  }
}
