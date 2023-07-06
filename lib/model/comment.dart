import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/model/user.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  String? id;
  int? userId;
  String? parentId;
  int? parentType;
  String? content;
  int? childrenNum;

  @JsonKey(includeFromJson: false, includeToJson: false)
  User? user;

  Comment();

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}

class CommentParentType {
  static const post = 1;
  static const comment = 2;
  static const gallery = 3;
  static const audio = 4;
  static const video = 5;
  static const article = 6;
}
