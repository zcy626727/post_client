class FeedType {
  static const post = 1;
  static const comment = 2;

  static const option = [
    (FeedType.post, "动态"),
    (FeedType.comment, "评论"),
  ];
}
