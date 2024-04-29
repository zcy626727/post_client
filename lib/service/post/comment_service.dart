import 'package:post_client/config/global.dart';
import 'package:post_client/constant/source.dart';
import 'package:post_client/service/post/feedback_service.dart';

import '../../api/client/post/comment_api.dart';
import '../../model/post/comment.dart';
import '../../model/post/feedback.dart';

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
    if (Global.user.id == null) {
      return;
    }
    //获取媒体列表
    var map = await FeedbackService.getFeedbackMap(commentList, SourceType.comment);

    //填充
    for (var comment in commentList) {
      comment.feedback = map[comment.id] ?? Feedback();
    }
  }

}
