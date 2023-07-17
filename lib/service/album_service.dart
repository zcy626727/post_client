import '../api/client/media/album_api.dart';
import '../model/album.dart';
import '../model/user.dart';

class AlbumService {
  static Future<Album> createAlbum(
    String title,
    String introduction,
    int? mediaType,
  ) async {
    var album = await AlbumApi.createAlbum(title, introduction, mediaType);
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

  static Future<List<Album>> getAlbumListByUserId(
    User user,
    int pageIndex,
    int pageSize,
  ) async {
    var albumList = await AlbumApi.getAlbumListByUserId(user.id!, pageIndex, pageSize);
    for (var album in albumList) {
      album.user = user;
    }
    return albumList;
  }
}
