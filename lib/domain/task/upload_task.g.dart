// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadTask _$UploadTaskFromJson(Map<String, dynamic> json) => UploadTask()
  ..id = json['id'] as int?
  ..userId = json['userId'] as int?
  ..fileName = json['fileName'] as String?
  ..srcPath = json['srcPath'] as String?
  ..resourceId = json['resourceId'] as int?
  ..totalSize = json['totalSize'] as int?
  ..uploadedSize = json['uploadedSize'] as int?
  ..md5 = json['md5'] as String?
  ..status = json['status'] as int?
  ..statusMessage = json['statusMessage'] as String?
  ..createTime = json['createTime'] == null
      ? null
      : DateTime.parse(json['createTime'] as String)
  ..taskParentFolderId = json['taskParentFolderId'] as int?
  ..parentId = json['parentId'] as int?
  ..type = json['type'] as int?;

Map<String, dynamic> _$UploadTaskToJson(UploadTask instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'fileName': instance.fileName,
      'srcPath': instance.srcPath,
      'resourceId': instance.resourceId,
      'totalSize': instance.totalSize,
      'uploadedSize': instance.uploadedSize,
      'md5': instance.md5,
      'status': instance.status,
      'statusMessage': instance.statusMessage,
      'createTime': instance.createTime?.toIso8601String(),
      'taskParentFolderId': instance.taskParentFolderId,
      'parentId': instance.parentId,
      'type': instance.type,
    };
