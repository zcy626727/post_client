import 'package:dio/dio.dart';

import '../../../model/message/live_topic.dart';
import '../message_http_config.dart';

class LiveTopicApi {
  static Future<List<LiveTopic>> getLiveTopicList() async {
    var r = await MessageHttpConfig.dio.get(
      "/liveTopic/getLiveTopicList",
      options: MessageHttpConfig.options.copyWith(extra: {
        "noCache": false,
        "withToken": false,
      }),
    );
    return _parseLiveTopicList(r);
  }

  static List<LiveTopic> _parseLiveTopicList(Response<dynamic> r) {
    List<LiveTopic> entityList = [];
    for (var json in r.data['topicList']) {
      var entity = LiveTopic.fromJson(json);
      entityList.add(entity);
    }
    return entityList;
  }
}
