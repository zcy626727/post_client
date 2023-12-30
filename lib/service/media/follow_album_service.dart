import 'package:post_client/api/client/media/follow_album_api.dart';
import 'package:post_client/model/media/follow_album.dart';

class FollowAlbumService {
  static Future<FollowAlbum> followAlbum({
    required String albumId,
  }) async {
    var followAlbum = await FollowAlbumApi.followAlbum(albumId: albumId);
    return followAlbum;
  }

  static Future<void> unfollowAlbum({
    required String followAlbumId,
  }) async {
    await FollowAlbumApi.unfollowAlbum(followAlbumId: followAlbumId);
    return;
  }

  static Future<FollowAlbum> getFollowAlbum({
    required String albumId,
  }) async {
    var followAlbum = await FollowAlbumApi.getFollowAlbum(albumId: albumId);
    return followAlbum;
  }
}
