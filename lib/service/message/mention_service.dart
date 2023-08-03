import 'package:post_client/api/client/message/mention_api.dart';
import 'package:post_client/config/global.dart';
import 'package:post_client/model/message/mention.dart';

class MentionService {
  static Future<List<Mention>> getReplyMentionList(
    int pageIndex,
    int pageSize,
  ) async {
    var mentionList = await MentionApi.getReplyMentionList(pageIndex, pageSize);
    //填充user
    for (var mention in mentionList) {
      mention.targetUser = Global.user;
    }
    //填充source
    await fillMentionSource(mentionList);
    return mentionList;
  }

  static Future<void> fillMentionSource(List<Mention> mentionList) async {
    List<String> postIdList = <String>[];
    List<String> commentIdList = <String>[];
    //获取媒体列表
    for (var mention in mentionList) {
      if (mention.sourceType != null) {
        switch (mention.sourceType) {
          case MentionSourceType.post:
            postIdList.add(mention.sourceId!);
          case MentionSourceType.comment:
            commentIdList.add(mention.sourceId!);
        }
      }
    }
    var (postMap, commentMap) = await MentionApi.getMentionSourceListByIdList(
      postIdList: postIdList,
      commentIdList: commentIdList,
    );

    //填充
    for (var mention in mentionList) {
      if (mention.sourceType != null) {
        switch (mention.sourceType) {
          case MentionSourceType.post:
            mention.source = postMap[mention.sourceId];
          case MentionSourceType.comment:
            mention.source = commentMap[mention.sourceId];
        }
      }
    }
  }
}
