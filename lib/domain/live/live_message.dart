import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/config/global.dart';

import '../../constant/chat_message.dart';

part 'live_message.g.dart';

@JsonSerializable(explicitToJson: true)
class LiveMessage {
  int? userId;
  int roomId;
  String? username;
  String content;
  int type;

  LiveMessage.joinRoom({this.userId, required this.roomId, this.username, this.content = "加入房间", this.type = ChatMessageType.joinRoom}) {
    userId = Global.user.id!;
    username = Global.user.name!;
  }

  LiveMessage.roomMessage({this.userId, required this.roomId, this.username, required this.content, this.type = ChatMessageType.roomMessage}) {
    userId = Global.user.id!;
    username = Global.user.name!;
  }

  factory LiveMessage.fromJson(Map<String, dynamic> json) => _$LiveMessageFromJson(json);

  Map<String, dynamic> toJson() => _$LiveMessageToJson(this);

  LiveMessage(this.userId, this.roomId, this.username, this.content, this.type);
}

