import 'package:json_annotation/json_annotation.dart';

import '../user/user.dart';

part 'user_interaction.g.dart';

@JsonSerializable()
class UserInteraction {
  int? id;
  int? firstId;
  int? secondId;
  int? unreadCount;
  DateTime? updateTime;
  @JsonKey(includeFromJson: false, includeToJson: false)
  User? user;

  UserInteraction();

  void copyLiveTopic(UserInteraction i) {
    id = i.id;
    firstId = i.firstId;
    secondId = i.secondId;
    id = i.id;
    unreadCount = i.unreadCount;
    updateTime = i.updateTime;
    user = i.user;
  }

  factory UserInteraction.fromJson(Map<String, dynamic> json) => _$UserInteractionFromJson(json);

  Map<String, dynamic> toJson() => _$UserInteractionToJson(this);
}
