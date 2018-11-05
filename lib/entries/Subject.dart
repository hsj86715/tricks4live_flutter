import 'User.dart';
import 'Label.dart';

class Subject {
  int id;
  String title;
  CategorySimple category;
  UserSimple user;
  String coverPicture;
  String content;
  String contentType;
  List<Steps> operateSteps;
  String videoUrl;
  int validCount;
  int invalidCount;
  bool isValidated = false;
  bool isInvalidated = false;
  bool isCollected = false;
  bool isFocused = false;
  List<Label> labels;
  DateTime createDate;
  DateTime updateDate;

  @override
  String toString() {
    return 'Subject{id: $id, title: $title, category: $category, user: $user, '
        'coverPicture: $coverPicture, content: $content, contentType: $contentType, '
        'operateSteps: $operateSteps, videoUrl: $videoUrl, validCount: $validCount, '
        'invalidCount: $invalidCount, isValidated: $isValidated, isInvalidated: $isInvalidated, '
        'isCollected: $isCollected, isFocused: $isFocused, labels: $labels, '
        'createDate: $createDate, updateDate: $updateDate}';
  }
}

class Steps {
  String operation;
  String picture;
  int timeCosts;

  @override
  String toString() {
    return 'Steps{operation: $operation, picture: $picture, timeCosts: $timeCosts}';
  }
}

class Comment {
  int id;
  int subjectId;
  UserSimple commenter;
  String content;
  int superId;
  int floor = 1;
  bool deleted = false;
  DateTime createDate;
  int agreeCount;
  Comment follow;

  @override
  String toString() {
    return 'Comment{id: $id, subjectId: $subjectId, commenter: $commenter, '
        'content: $content, superId: $superId, floor: $floor, deleted: $deleted, '
        'createDate: $createDate, agreeCount: $agreeCount, follow: $follow}';
  }
}

class CategorySimple {
  int id;
  String nameCN;
  String nameEN;

  CategorySimple(this.nameCN, this.nameEN, {this.id});

  @override
  String toString() {
    return 'CategorySimple{id: $id, nameCN: $nameCN, nameEN: $nameEN}';
  }
}
