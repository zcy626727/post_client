import '../../api/client/post/album_api.dart';
import '../../model/post/album.dart';
import '../../model/user/user.dart';

class AlbumService {
  static Future<Album> createAlbum(
    String title,
    String introduction,
    int mediaType,
    String? coverUrl,
  ) async {
    var album = await AlbumApi.createAlbum(title, introduction, mediaType, coverUrl);
    return album;
  }

  static Future<void> deleteUserAlbumById(String albumId,) async {
    await AlbumApi.deleteUserAlbumById(albumId);
  }

  static Future<Album> getAlbumById(String albumId,) async {
    var album = await AlbumApi.getAlbumById(albumId);
    return album;
  }

  static Future<void> updateAlbumInfo({
    required String albumId,
    String? title,
    String? introduction,
    String? coverUrl,
  }) async {
    await AlbumApi.updateAlbumInfo(
      albumId: albumId,
      coverUrl: coverUrl,
      title: title,
      introduction: introduction,
    );
  }

  static Future<List<Album>> getUserAlbumList(User user,
      int mediaType,
      int pageIndex,
      int pageSize,) async {
    var albumList = await AlbumApi.getUserAlbumList(user.id!, mediaType, pageIndex, pageSize);
    for (var album in albumList) {
      album.user = user;
    }
    return albumList;
  }

  static Future<List<Album>> getAlbumListRandom(int pageSize,) async {
    var albumList = await AlbumApi.getAlbumListRandom(pageSize);
    return albumList;
  }

  static Future<List<Album>> getAlbumListByUserId(User user,
      int pageIndex,
      int pageSize,) async {
    var albumList = await AlbumApi.getAlbumListByUserId(user.id!, pageIndex, pageSize);
    for (var album in albumList) {
      album.user = user;
    }
    return albumList;
  }

  static Future<List<Album>> searchAlbum(String title,
      int page,
      int pageSize,) async {
    var albumList = await AlbumApi.searchAlbum(title, page, pageSize);
    return albumList;
  }

}
