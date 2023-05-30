import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/model/media.dart';
import 'package:post_client/model/user.dart';

@JsonSerializable()
class Post {
  int? id;
  int? contentType;
  //文字内容，只包含文字 @ #
  String? text;
  //评论数
  int? commentNumber;
  //点赞数
  int? likeNumber;
  //图片布局，九宫格或大图
  List<String>? pictrueUrlList;
  //媒体
  Media? media;
  //post所有者
  User? user;

  Post.one() {
    id = 1;
    text = "这是一条动态";
    contentType = PostContentType.article;
    likeNumber = 1;
    commentNumber = 4;
  }
}

class PostContentType {
  //媒体
  static const image = 1;
  static const article = 2;
  static const audio = 3;
  static const video = 4;
  //合集
  static const collection = 5;
  //动态
  static const post = 6;
  //纯quill文本
  static const text = 7;
  //带配图
  static const picture = 8;
}
