class SourceType {
  //媒体
  static const gallery = 1;
  static const article = 2;
  static const audio = 3;
  static const video = 4;

  static const comment = 5;

  //动态
  static const post = 6;

  static const album = 7;

  static const favoritesSourceOption = [
    (SourceType.post, "动态"),
    (SourceType.comment, "评论"),
    (SourceType.audio, "音频"),
    (SourceType.video, "视频"),
    (SourceType.gallery, "图片"),
    (SourceType.article, "文章"),
  ];
}


