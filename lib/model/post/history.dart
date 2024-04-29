import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/model/post/media.dart';

part 'history.g.dart';

@JsonSerializable()
class History{
  String? id;
  int? userId;
  int? mediaType;
  String? mediaId;
  String? position;
  DateTime? updateTime;
  DateTime? createTime;

  @JsonKey(includeFromJson: false, includeToJson: false)
  Media? media;


  History();

  factory History.fromJson(Map<String, dynamic> json) => _$HistoryFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}