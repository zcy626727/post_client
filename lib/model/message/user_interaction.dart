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

  // 除了自己外另一个人的信息
  @JsonKey(includeFromJson: false, includeToJson: false)
  User? otherUser;

  UserInteraction();

  void copyLiveTopic(UserInteraction i) {
    id = i.id;
    firstId = i.firstId;
    secondId = i.secondId;
    unreadCount = i.unreadCount;
    updateTime = i.updateTime;
    otherUser = i.otherUser;
  }

  factory UserInteraction.fromJson(Map<String, dynamic> json) => _$UserInteractionFromJson(json);

  Map<String, dynamic> toJson() => _$UserInteractionToJson(this);
}
