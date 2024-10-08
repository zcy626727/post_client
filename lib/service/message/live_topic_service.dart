
import '../../api/client/message/live_topic_api.dart';
import '../../model/message/live_topic.dart';

class LiveTopicService {
  static Future<List<LiveTopic>> getLiveTopicList() async {
    return await LiveTopicApi.getLiveTopicList();
  }
}
