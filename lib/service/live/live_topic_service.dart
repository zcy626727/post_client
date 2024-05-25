import 'package:post_client/model/live/live_topic.dart';

import '../../api/client/message/live_topic_api.dart';

class LiveTopicService {
  static Future<List<LiveTopic>> getCategoryListByTopic() async {
    return await LiveTopicApi.getLiveTopicList();
  }
}
