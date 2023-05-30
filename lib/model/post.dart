import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/model/media.dart';

@JsonSerializable()
class Post {
  int? id;
  //类型，图片、影音、动态、合集
  int? contentType;
  //文字内容，只包含文字 @ #
  String? text;
  //评论数
  int? commentNumber;
  //点赞数
  int? likeNumber;
  //图片布局，九宫格或大图
  int? pictrueLayout;
  List<String>? pictrueUrlList;
  //媒体类型
  Media? media;

  Post.one() {
    id = 1;
    text = "内容";
  }
}

enum PostContentType {
  //一般
  picture,
  //媒体
  image,
  article,
  audio,
  video,
  //合集
  collection,
  //动态
  post,
}
