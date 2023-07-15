import 'package:json_annotation/json_annotation.dart';


part 'follow.g.dart';

@JsonSerializable()
class Follow{
  String? id;
  int? userId;
  int? mediaType;
  List<String>? mediaIdList;
  DateTime? createTime;

  Follow();

  factory Follow.fromJson(Map<String, dynamic> json) => _$FollowFromJson(json);

  Map<String, dynamic> toJson() => _$FollowToJson(this);
}