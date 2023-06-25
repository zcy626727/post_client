// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_media_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadMediaTask _$UploadMediaTaskFromJson(Map<String, dynamic> json) =>
    UploadMediaTask()
      ..id = json['id'] as int?
      ..fileName = json['fileName'] as String?
      ..srcPath = json['srcPath'] as String?
      ..totalSize = json['totalSize'] as int?
      ..uploadedSize = json['uploadedSize'] as int?
      ..md5 = json['md5'] as String?
      ..statusMessage = json['statusMessage'] as String?
      ..status = json['status'] as int?
      ..createTime = json['createTime'] == null
          ? null
          : DateTime.parse(json['createTime'] as String)
      ..mediaType = json['mediaType'] as int?
      ..private = json['private'] as bool
      ..link = json['link'] as String?;

Map<String, dynamic> _$UploadMediaTaskToJson(UploadMediaTask instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'srcPath': instance.srcPath,
      'totalSize': instance.totalSize,
      'uploadedSize': instance.uploadedSize,
      'md5': instance.md5,
      'statusMessage': instance.statusMessage,
      'status': instance.status,
      'createTime': instance.createTime?.toIso8601String(),
      'mediaType': instance.mediaType,
      'private': instance.private,
      'link': instance.link,
    };
