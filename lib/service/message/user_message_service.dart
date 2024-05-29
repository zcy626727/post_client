import 'package:post_client/api/client/message/chat_message_api.dart';

import '../../model/message/user_interaction.dart';
import '../../model/message/user_message.dart';

class UserMessageService {
  static Future<List<UserMessage>> getUserMessageListByInteraction({
    required int interactionId,
    required int pageIndex,
    required int pageSize,
    required DateTime startTime,
  }) async {
    return await UserMessageApi.getUserMessageListByInteraction(interactionId: interactionId, pageIndex: pageIndex, pageSize: pageSize, startTime: startTime);
  }

  static Future<List<UserInteraction>> getInteractionList({
    required int pageIndex,
    required int pageSize,
    required DateTime startTime,
  }) async {
    return await UserMessageApi.getInteractionList(pageIndex: pageIndex, pageSize: pageSize, startTime: startTime);
  }

  static Future<UserInteraction> getInteraction({
    required int targetUserId,
  }) async {
    return await UserMessageApi.getInteraction(targetUserId: targetUserId);
  }
}
