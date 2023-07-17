import '../api/client/message/comment_api.dart';
import '../model/comment.dart';

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
    return commentList;
  }
}
