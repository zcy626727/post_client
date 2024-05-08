// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multipart_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultipartInfo _$MultipartInfoFromJson(Map<String, dynamic> json) =>
    MultipartInfo(
      json['md5'] as String?,
      (json['file_id'] as num?)?.toInt(),
      json['finished'] as bool?,
      (json['total_part_num'] as num?)?.toInt(),
      (json['uploaded_part_num'] as num?)?.toInt(),
      (json['file_size'] as num?)?.toInt(),
      (json['part_size'] as num?)?.toInt(),
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
