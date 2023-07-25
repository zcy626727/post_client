import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/model/media/media.dart';
import 'package:post_client/model/user/user.dart';

part 'audio.g.dart';

@JsonSerializable()
class Audio extends Media{
  int? fileId;

  @JsonKey(includeFromJson: false, includeToJson: false)
  User? user;

  Audio();

  void copyAudio(Audio audio) {
    super.copy(audio);
    fileId = audio.fileId;
    user = audio.user;
  }

  factory Audio.fromJson(Map<String, dynamic> json) => _$AudioFromJson(json);

  Map<String, dynamic> toJson() => _$AudioToJson(this);
}