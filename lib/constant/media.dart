class MediaType {
  static const gallery = 1;
  static const audio = 2;
  static const video = 3;
  static const article = 4;

  static const option = [
    (MediaType.audio, "音频"),
    (MediaType.video, "视频"),
    (MediaType.gallery, "图片"),
    (MediaType.article, "文章"),
  ];
}
