import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/model/post/media.dart';
import 'package:post_client/model/post/source.dart';
import 'package:post_client/model/user/user.dart';

import '../../constant/source.dart';
import 'feedback.dart';

part 'post.g.dart';

@JsonSerializable()
class Post extends Source {
  int? userId;
  String? sourceId;
  int? sourceType;
  DateTime? createTime;

  //文字内容，只包含文字 @ #
  String? content;

  //评论数
  int? commentNum;

  //图片布局，九宫格或大图
  List<String>? pictureUrlList;

  //媒体
  @JsonKey(includeFromJson: false, includeToJson: false)
  Media? media;

  //post所有者
  @JsonKey(includeFromJson: false, includeToJson: false)
  User? user;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Feedback? feedback;

  Post.one() {
    // id = 1;
    content = "这是一条动态";
    likeNum = 1;
    likeNum = 1;
    commentNum = 4;
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
    return sourceType == SourceType.article ||
        sourceType == SourceType.gallery ||
        sourceType == SourceType.audio ||
        sourceType == SourceType.video ||
        sourceType == SourceType.album ||
        sourceType == SourceType.post;
  }

  bool hasMedia() {
    return sourceType == SourceType.article || sourceType == SourceType.gallery || sourceType == SourceType.audio || sourceType == SourceType.video;
  }

  Post();

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}


