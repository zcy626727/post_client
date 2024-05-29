import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/config/global.dart';

import '../../constant/chat_message.dart';

part 'live_message.g.dart';

@JsonSerializable(explicitToJson: true)
class ChatMessage {
  int? userId;
  int? roomId;
  int? targetUserId;
  String? username;
  String content;
  int type;

  ChatMessage.joinRoom({this.userId, required this.roomId, this.username, this.content = "加入房间", this.type = ChatMessageType.joinRoom}) {
    userId = Global.user.id!;
    username = Global.user.name!;
  }

  ChatMessage.userJoin({this.userId, this.content = "", this.type = ChatMessageType.userJoin}) {
    userId = Global.user.id!;
  }

  ChatMessage.userMessage({this.userId, required this.targetUserId, required this.content, this.type = ChatMessageType.userMessage}) {
    userId = Global.user.id!;
  }

  ChatMessage.roomMessage({this.userId, required this.roomId, this.username, required this.content, this.type = ChatMessageType.roomMessage}) {
    userId = Global.user.id!;
    username = Global.user.name!;
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  ChatMessage(this.userId, this.roomId, this.username, this.content, this.type);
}
