import 'package:json_annotation/json_annotation.dart';

part 'history.g.dart';

@JsonSerializable()
class History{
  String? id;
  int? userId;
  int? mediaType;
  String? mediaId;
  String? position;
  DateTime? createTime;

  History();

  factory History.fromJson(Map<String, dynamic> json) => _$HistoryFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}