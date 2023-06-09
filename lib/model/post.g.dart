// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post()
  ..id = json['id'] as int?
  ..contentType = json['contentType'] as int?
  ..text = json['text'] as String?
  ..commentNumber = json['commentNumber'] as int?
  ..likeNumber = json['likeNumber'] as int?
  ..pictureUrlList = (json['pictureUrlList'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList();

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'contentType': instance.contentType,
      'text': instance.text,
      'commentNumber': instance.commentNumber,
      'likeNumber': instance.likeNumber,
      'pictureUrlList': instance.pictureUrlList,
    };
