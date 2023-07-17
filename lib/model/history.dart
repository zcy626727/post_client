import 'package:json_annotation/json_annotation.dart';

part 'history.g.dart';

@JsonSerializable()
class History{
  String? id;
  int? userId;
  int? sourceType;
  String? sourceId;
  String? position;
  DateTime? createTime;

  @JsonKey(includeFromJson: false, includeToJson: false)
  dynamic source;


  History();

  factory History.fromJson(Map<String, dynamic> json) => _$HistoryFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}