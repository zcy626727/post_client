import 'package:json_annotation/json_annotation.dart';

part 'multipart_info.g.dart';

@JsonSerializable()
class MultipartInfo {
  String? md5;
  String? fileName;
  bool? finished;
  int? totalPartNum;
  int? uploadedPartNum;
  int? fileSize;
  int? partSize;

  MultipartInfo(
    this.md5,
    this.fileName,
    this.finished,
    this.totalPartNum,
    this.uploadedPartNum,
    this.fileSize,
    this.partSize,
  );

  factory MultipartInfo.fromJson(Map<String, dynamic> json) =>
      _$MultipartInfoFromJson(json);

  Map<String, dynamic> toJson() => _$MultipartInfoToJson(this);
}
