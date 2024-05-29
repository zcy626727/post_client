import 'package:dio/dio.dart';
import 'package:post_client/config/global.dart';
import 'package:post_client/model/message/user_interaction.dart';
import 'package:post_client/model/message/user_message.dart';
import 'package:post_client/util/time.dart';

import '../../../model/user/user.dart';
import '../message_http_config.dart';

class UserMessageApi {
  static Future<List<UserMessage>> getUserMessageListByInteraction({
    required int interactionId,
    required int pageIndex,
    required int pageSize,
    required DateTime startTime,
  }) async {
    var r = await MessageHttpConfig.dio.get(
      "/userMessage/getUserMessageListByInteraction",
      queryParameters: {"interactionId": interactionId, "pageIndex": pageIndex, "pageSize": pageSize, "startTime": DateTimeUtil.formatRFC3339(startTime)},
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

  static Future<List<UserInteraction>> getInteractionList({
    required int pageIndex,
    required int pageSize,
    required DateTime startTime,
  }) async {
    var r = await MessageHttpConfig.dio.get(
      "/userMessage/getInteractionList",
      queryParameters: {"pageIndex": pageIndex, "pageSize": pageSize, "startTime": DateTimeUtil.formatRFC3339(startTime)},
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return _parseInteractionList(r);
  }

  //获取自己和其他人的交互信息
  static Future<UserInteraction> getInteraction({
    required int targetUserId,
  }) async {
    var r = await MessageHttpConfig.dio.get(
      "/userMessage/getInteraction",
      queryParameters: {"targetUserId": targetUserId},
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return UserInteraction.fromJson(r.data['interaction']);
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
        if (e.firstId == Global.user.id) {
          e.otherUser = userMap[e.secondId];
        } else {
          e.otherUser = userMap[e.firstId];
        }
        list.add(e);
      }
    }
    return list;
  }
}
