import 'package:post_client/api/client/post/follow_album_api.dart';
import 'package:post_client/model/post/follow_album.dart';

class FollowAlbumService {
  static Future<FollowAlbum> followAlbum({
    required String albumId,
    int? mediaType,
  }) async {
    var followAlbum = await FollowAlbumApi.followAlbum(albumId: albumId, mediaType: mediaType);
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

  static Future<List<FollowAlbum>> getUserFollowAlbumList({
    int pageIndex = 0,
    int pageSize = 20,
    int? mediaType,
    required bool withUser,
  }) async {
    var followAlbumList = await FollowAlbumApi.getUserFollowAlbumList(pageIndex: pageIndex, pageSize: pageSize, withUser: withUser, mediaType: mediaType);
    return followAlbumList;
  }
}
