class Media {
  String? id;
  int? userId;
  String? title;
  String? coverUrl;
  DateTime? createTime;
  String? introduction;
  String? albumId;

  int? likeNum;
  int? dislikeNum;
  int? favoritesNum;
  int? shareNum;

  void copy(Media newMedia) {
    id = newMedia.id;
    userId = newMedia.userId;
    title = newMedia.title;
    albumId = newMedia.albumId;
    coverUrl = newMedia.coverUrl;
    createTime = newMedia.createTime;
    introduction = newMedia.introduction;
    likeNum = newMedia.likeNum;
    dislikeNum = newMedia.dislikeNum;
    favoritesNum = newMedia.favoritesNum;
    shareNum = newMedia.shareNum;
  }
}
