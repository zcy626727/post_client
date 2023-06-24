import 'package:json_annotation/json_annotation.dart';


part 'message_notion.g.dart';

@JsonSerializable(explicitToJson: true)
class MessageNotion{
  MessageNotion(this.type,this.message);
  int type;
  String message;

  factory MessageNotion.fromJson(Map<String, dynamic> json) => _$MessageNotionFromJson(json);

  Map<String, dynamic> toJson() => _$MessageNotionToJson(this);
}

enum MessageNotionType{
  uploadImage,
  uploadVideo,
  uploadAudio,
}