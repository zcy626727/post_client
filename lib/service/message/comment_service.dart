import 'package:post_client/constant/feed.dart';
import 'package:post_client/service/message/feed_service.dart';

import '../../api/client/message/comment_api.dart';
import '../../model/message/comment.dart';
import '../../model/message/feed_feedback.dart';

class CommentService {
  static Future<Comment> createComment(
    String parentId,
    int parentType,
    int parentUserId,
    List<int> targetUserIdList,
    String content,
  ) async {
    var comment = await CommentApi.createComment(parentId, parentType, parentUserId, targetUserIdList, content);
    return comment;
  }

  static Future<void> deleteComment(
    String commentId,
  ) async {
    await CommentApi.deleteCommentById(commentId);
  }

  static Future<List<Comment>> getCommentListByParent(
    String parentId,
    int parentType,
    int pageIndex,
    int pageSize,
  ) async {
    var commentList = await CommentApi.getCommentListByParent(parentId, parentType, pageIndex, pageSize);
    await fillFeedback(commentList);
    return commentList;
  }

  static Future<Comment> getCommentById(
    String commentId,
  ) async {
    var comment = await CommentApi.getCommentById(commentId);
    return comment;
  }

  static Future<List<Comment>> getReplyCommentList(
    int pageIndex,
    int pageSize,
  ) async {
    var commentList = await CommentApi.getReplyCommentList(pageIndex, pageSize);
    await fillFeedback(commentList);
    return commentList;
  }

  static Future<void> fillFeedback(List<Comment> commentList) async {
    //获取媒体列表
    var map = await FeedService.getFeedbackMap(commentList, FeedType.comment);

    //填充
    for (var comment in commentList) {
      comment.feedback = map[comment.id]??FeedFeedback();
    }
  }

}
