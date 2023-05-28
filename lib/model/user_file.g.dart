// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFile _$UserFileFromJson(Map<String, dynamic> json) => UserFile(
      json['id'],
      json['name'],
      json['status'],
      json['userId'] as int?,
      json['parentId'] as int?,
      json['md5'] as String?,
      json['fileSize'] as int?,
      json['createTime'] == null
          ? null
          : DateTime.parse(json['createTime'] as String),
      json['expireTime'] == null
          ? null
          : DateTime.parse(json['expireTime'] as String),
    );

Map<String, dynamic> _$UserFileToJson(UserFile instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'userId': instance.userId,
      'parentId': instance.parentId,
      'md5': instance.md5,
      'fileSize': instance.fileSize,
      'createTime': instance.createTime?.toIso8601String(),
      'expireTime': instance.expireTime?.toIso8601String(),
    };
