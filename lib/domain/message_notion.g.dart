// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_notion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageNotion _$MessageNotionFromJson(Map<String, dynamic> json) =>
    MessageNotion(
      (json['type'] as num).toInt(),
      json['message'] as String,
    );

Map<String, dynamic> _$MessageNotionToJson(MessageNotion instance) =>
    <String, dynamic>{
      'type': instance.type,
      'message': instance.message,
    };
