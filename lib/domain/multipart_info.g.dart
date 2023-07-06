// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multipart_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultipartInfo _$MultipartInfoFromJson(Map<String, dynamic> json) =>
    MultipartInfo(
      json['md5'] as String?,
      json['file_id'] as int?,
      json['finished'] as bool?,
      json['total_part_num'] as int?,
      json['uploaded_part_num'] as int?,
      json['file_size'] as int?,
      json['part_size'] as int?,
    );

Map<String, dynamic> _$MultipartInfoToJson(MultipartInfo instance) =>
    <String, dynamic>{
      'md5': instance.md5,
      'file_id': instance.fileId,
      'finished': instance.finished,
      'total_part_num': instance.totalPartNum,
      'uploaded_part_num': instance.uploadedPartNum,
      'file_size': instance.fileSize,
      'part_size': instance.partSize,
    };
