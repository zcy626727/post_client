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
  List<String>? pictureUrlList;

  //媒体
  Media? media;

  //post所有者
  User? user;

  Post.one() {
    id = 1;
    text = "这是一条动态";
    contentType = PostContentType.text;
    likeNumber = 1;
    commentNumber = 4;
    pictureUrlList = <String>[
      "https://pic4.zhimg.com/e32d48b88ae8491a39e6b96e29af7447_r.jpg?source=1940ef5c",
      "https://pic4.zhimg.com/e32d48b88ae8491a39e6b96e29af7447_r.jpg?source=1940ef5c",
      "https://pic4.zhimg.com/e32d48b88ae8491a39e6b96e29af7447_r.jpg?source=1940ef5c",
      "https://pic4.zhimg.com/e32d48b88ae8491a39e6b96e29af7447_r.jpg?source=1940ef5c",
      "https://pic4.zhimg.com/e32d48b88ae8491a39e6b96e29af7447_r.jpg?source=1940ef5c",
      "https://pic4.zhimg.com/e32d48b88ae8491a39e6b96e29af7447_r.jpg?source=1940ef5c",
      "https://pic4.zhimg.com/e32d48b88ae8491a39e6b96e29af7447_r.jpg?source=1940ef5c",
      "https://pic4.zhimg.com/e32d48b88ae8491a39e6b96e29af7447_r.jpg?source=1940ef5c",
      "https://pic4.zhimg.com/e32d48b88ae8491a39e6b96e29af7447_r.jpg?source=1940ef5c",
      "https://pic4.zhimg.com/e32d48b88ae8491a39e6b96e29af7447_r.jpg?source=1940ef5c",
    ];
  }

  bool isInnerMode() {
    return contentType == PostContentType.article ||
        contentType == PostContentType.image ||
        contentType == PostContentType.audio ||
        contentType == PostContentType.video ||
        contentType == PostContentType.collection ||
        contentType == PostContentType.post;
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

  //quill文本，可能带图
  static const text = 7;
}
