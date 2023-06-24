// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multipart_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultipartInfo _$MultipartInfoFromJson(Map<String, dynamic> json) =>
    MultipartInfo(
      json['md5'] as String?,
      json['fileName'] as String?,
      json['finished'] as bool?,
      json['totalPartNum'] as int?,
      json['uploadedPartNum'] as int?,
      json['fileSize'] as int?,
      json['partSize'] as int?,
    );

Map<String, dynamic> _$MultipartInfoToJson(MultipartInfo instance) =>
    <String, dynamic>{
      'md5': instance.md5,
      'fileName': instance.fileName,
      'finished': instance.finished,
      'totalPartNum': instance.totalPartNum,
      'uploadedPartNum': instance.uploadedPartNum,
      'fileSize': instance.fileSize,
      'partSize': instance.partSize,
    };
