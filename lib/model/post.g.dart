// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post()
  ..id = json['id'] as String?
  ..userId = json['userId'] as int?
  ..sourceId = json['sourceId'] as String?
  ..sourceType = json['sourceType'] as int?
  ..createTime = json['createTime'] == null
      ? null
      : DateTime.parse(json['createTime'] as String)
  ..content = json['content'] as String?
  ..contentType = json['contentType'] as int?
  ..commentNumber = json['commentNumber'] as int?
  ..likeNumber = json['likeNumber'] as int?
  ..unlikeNumber = json['unlikeNumber'] as int?
  ..pictureUrlList = (json['pictureUrlList'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList();

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'sourceId': instance.sourceId,
      'sourceType': instance.sourceType,
      'createTime': instance.createTime?.toIso8601String(),
      'content': instance.content,
      'contentType': instance.contentType,
      'commentNumber': instance.commentNumber,
      'likeNumber': instance.likeNumber,
      'unlikeNumber': instance.unlikeNumber,
      'pictureUrlList': instance.pictureUrlList,
    };
