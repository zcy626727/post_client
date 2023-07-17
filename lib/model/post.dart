import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/model/media.dart';
import 'package:post_client/model/user.dart';

import '../constant/post.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  String? id;
  int? userId;
  String? sourceId;
  int? sourceType;
  DateTime? createTime;

  //文字内容，只包含文字 @ #
  String? content;

  //评论数
  int? commentNumber;

  //点赞数
  int? likeNumber;
  int? unlikeNumber;

  //图片布局，九宫格或大图
  List<String>? pictureUrlList;

  //媒体
  @JsonKey(includeFromJson: false, includeToJson: false)
  Media? media;

  //post所有者
  @JsonKey(includeFromJson: false, includeToJson: false)
  User? user;

  Post.one() {
    // id = 1;
    content = "这是一条动态";
    likeNumber = 1;
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

  bool isSourceMode() {
    return sourceType == PostSourceType.article ||
        sourceType == PostSourceType.gallery ||
        sourceType == PostSourceType.audio ||
        sourceType == PostSourceType.video ||
        sourceType == PostSourceType.album ||
        sourceType == PostSourceType.post;
  }

  bool hasMedia() {
    return sourceType == PostSourceType.article || sourceType == PostSourceType.gallery || sourceType == PostSourceType.audio || sourceType == PostSourceType.video;
  }

  Post();

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}


