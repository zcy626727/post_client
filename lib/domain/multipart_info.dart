import 'package:json_annotation/json_annotation.dart';

part 'multipart_info.g.dart';

@JsonSerializable()
class MultipartInfo {
  String? md5;
  @JsonKey(name: 'file_id')
  int? fileId;
  bool? finished;
  @JsonKey(name: 'total_part_num')
  int? totalPartNum;
  @JsonKey(name: 'uploaded_part_num')
  int? uploadedPartNum;
  @JsonKey(name: 'file_size')
  int? fileSize;
  @JsonKey(name: 'part_size')
  int? partSize;

  MultipartInfo(
    this.md5,
    this.fileId,
    this.finished,
    this.totalPartNum,
    this.uploadedPartNum,
    this.fileSize,
    this.partSize,
  );

  factory MultipartInfo.fromJson(Map<String, dynamic> json) => _$MultipartInfoFromJson(json);

  Map<String, dynamic> toJson() => _$MultipartInfoToJson(this);
}
