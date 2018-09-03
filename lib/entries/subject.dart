import 'user.dart';
import 'label.dart';

class Subject {
  int id;
  String title;
  int categoryId;
  UserSimple user;
  String content;
  String contentType;
  List<String> picUrls;
  String videoUrl;
  int validCount;
  int invalidCount;
  List<Label> labels;
  DateTime createDate;

  @override
  String toString() {
    return 'Subject{id: $id, title: $title, categoryId: $categoryId, user: $user, '
        'content: $content, contentType: $contentType, picUrls: $picUrls, '
        'videoUrl: $videoUrl, validCount: $validCount, invalidCount: $invalidCount, '
        'labels: $labels, createDate: $createDate}';
  }
}
