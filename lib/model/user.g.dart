// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int?,
      phoneNumber: json['phoneNumber'] as String?,
      lastLoginTime: json['lastLoginTime'] as String?,
      token: json['token'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      name: json['name'] as String?,
      themeMode: json['themeMode'] as int? ?? 0,
      blacklistNumber: json['blacklistNumber'] as int?,
      followerNumber: json['followerNumber'] as int?,
      followNumber: json['followNumber'] as int?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'id': instance.id,
      'name': instance.name,
      'token': instance.token,
      'lastLoginTime': instance.lastLoginTime,
      'avatarUrl': instance.avatarUrl,
      'followerNumber': instance.followerNumber,
      'followNumber': instance.followNumber,
      'blacklistNumber': instance.blacklistNumber,
      'themeMode': instance.themeMode,
    };
