import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/domain/live/live_message.dart';

part 'user_message.g.dart';

@JsonSerializable()
class UserMessage {
  int? id;
  int? interactionId;
  int? fromId;
  int? toId;
  String? content;
  DateTime? createTime;

  UserMessage();

  void copyUserMessage(UserMessage i) {
    id = i.id;
    interactionId = i.interactionId;
    fromId = i.fromId;
    toId = i.toId;
    content = i.content;
    createTime = i.createTime;
  }

  UserMessage.fromChatMessage(ChatMessage msg) {
    fromId = msg.userId;
    toId = msg.targetUserId;
    content = msg.content;
    createTime = DateTime.now();
  }

  factory UserMessage.fromJson(Map<String, dynamic> json) => _$UserMessageFromJson(json);

  Map<String, dynamic> toJson() => _$UserMessageToJson(this);
}
