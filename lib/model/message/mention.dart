import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/model/user/user.dart';

import '../media/media.dart';

part 'mention.g.dart';

@JsonSerializable()
class Mention {
  String? id;
  int? targetUserId;
  int? sourceUserId;
  int? sourceType;
  String? sourceId;
  DateTime? createTime;

  @JsonKey(includeFromJson: false, includeToJson: false)
  User? sourceUser;

  @JsonKey(includeFromJson: false, includeToJson: false)
  User? targetUser;

  @JsonKey(includeFromJson: false, includeToJson: false)
  dynamic source;

  Mention();

  factory Mention.fromJson(Map<String, dynamic> json) => _$MentionFromJson(json);

  Map<String, dynamic> toJson() => _$MentionToJson(this);
}

class MentionSourceType{
  static const post = 1;
  static const comment = 2;
}
