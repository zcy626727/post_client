import 'package:post_client/api/client/post_api.dart';
import 'package:post_client/model/post.dart';

import '../model/comment.dart';

class CommentService {
  static Future<Comment> createComment(
    String parentId,
    int parentType,
    String content,
  ) async {
    var comment = await CommentApi.createComment(parentId, parentType, content);
    return comment;
  }

  static Future<void> deleteComment(
    String commentId,
  ) async {
    await CommentApi.deleteComment(commentId);
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
}
