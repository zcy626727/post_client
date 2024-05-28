import 'package:dio/dio.dart';
import 'package:post_client/model/message/user_interaction.dart';
import 'package:post_client/model/message/user_message.dart';

import '../../../model/user/user.dart';
import '../message_http_config.dart';

class UserMessageApi {
  static Future<List<UserMessage>> getUserMessageByInteraction({
    required int interactionId,
    required int pageIndex,
    required int pageSize,
    required DateTime startTime,
  }) async {
    var r = await MessageHttpConfig.dio.get(
      "/userMessage/getUserMessageByInteraction",
      queryParameters: {"interactionId": interactionId, "pageIndex": pageIndex, "pageSize": pageSize, "startTime": startTime},
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return _parseUserMessageList(r);
  }

  static List<UserMessage> _parseUserMessageList(Response<dynamic> r) {
    List<UserMessage> list = [];
    for (var json in r.data['messageList']) {
      var e = UserMessage.fromJson(json);
      list.add(e);
    }
    return list;
  }

  static Future<List<UserInteraction>> getInteractionList() async {
    var r = await MessageHttpConfig.dio.get(
      "/userMessage/getInteractionList",
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return _parseInteractionList(r);
  }

  static List<UserInteraction> _parseInteractionList(Response<dynamic> r) {
    Map<int, User> userMap = {};
    if (r.data['userList'] != null) {
      for (var userJson in r.data['userList']) {
        var user = User.fromJson(userJson);
        userMap[user.id ?? 0] = user;
      }
    }
    List<UserInteraction> list = [];
    if (r.data['interactionList'] != null) {
      for (var json in r.data['interactionList']) {
        var e = UserInteraction.fromJson(json);
        e.user = userMap[e.firstId];
        list.add(e);
      }
    }
    return list;
  }
}
