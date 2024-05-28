import 'package:post_client/api/client/message/chat_message_api.dart';

import '../../model/message/user_interaction.dart';
import '../../model/message/user_message.dart';

class LiveRoomService {
  static Future<List<UserMessage>> getUserMessageByInteraction({
    required int interactionId,
    required int pageIndex,
    required int pageSize,
    required DateTime startTime,
  }) async {
    return await UserMessageApi.getUserMessageByInteraction(interactionId: interactionId, pageIndex: pageIndex, pageSize: pageSize, startTime: startTime);
  }

  static Future<List<UserInteraction>> getInteractionList() async {
    return await UserMessageApi.getInteractionList();
  }
}
