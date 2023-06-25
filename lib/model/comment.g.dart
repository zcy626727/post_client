// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment()
  ..id = json['id'] as String?
  ..userId = json['userId'] as int?
  ..parentId = json['parentId'] as String?
  ..parentType = json['parentType'] as int?
  ..content = json['content'] as String?
  ..childrenNum = json['childrenNum'] as int?;

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'parentId': instance.parentId,
      'parentType': instance.parentType,
      'content': instance.content,
      'childrenNum': instance.childrenNum,
    };
