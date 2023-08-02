import '../../api/client/media/album_api.dart';
import '../../model/media/album.dart';
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

  static Future<void> deleteAlbum(
    String albumId,
  ) async {
    await AlbumApi.deleteUserAlbumById(albumId);
  }

  static Future<Album> getAlbumById(
    String albumId,
  ) async {
    var album = await AlbumApi.getAlbumByIdWithMedia(albumId);
    return album;
  }

  static Future<List<Album>> getUserAlbumList(
    User user,
    int mediaType,
    int pageIndex,
    int pageSize,
  ) async {
    var albumList = await AlbumApi.getUserAlbumList(user.id!, mediaType, pageIndex, pageSize);
    for (var album in albumList) {
      album.user = user;
    }
    return albumList;
  }

  static Future<List<Album>> searchAlbum(
    String title,
    int size,
  ) async {
    var albumList = await AlbumApi.searchAlbum(title, size);
    return albumList;
  }
}
