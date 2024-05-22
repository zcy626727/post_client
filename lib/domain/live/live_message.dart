import 'package:json_annotation/json_annotation.dart';

part 'live_message.g.dart';

@JsonSerializable(explicitToJson: true)
class LiveMessage {
  int userId;
  int roomId;
  String content;
  int type;

  factory LiveMessage.fromJson(Map<String, dynamic> json) => _$LiveMessageFromJson(json);

  Map<String, dynamic> toJson() => _$LiveMessageToJson(this);

  LiveMessage(this.userId, this.roomId, this.content, this.type);
}

class LiveMessageType {
  static int message = 1;
  static int join = 2;
  static int exit = 3;
}
