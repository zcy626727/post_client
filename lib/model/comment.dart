import 'package:post_client/model/user.dart';

class Comment{
  int? id;
  int? userId;
  User? user;
  int? parentId;
  String? text;
  Comment.one() {
    id = 1;
    userId = 11;
    user = User.one();
    text = "退！退！退！";
    parentId = 0;
  }
  Comment.two() {
    id = 2;
    userId = 11;
    user = User.one();
    text = "退！退！退！";
    parentId = 1;
  }
}