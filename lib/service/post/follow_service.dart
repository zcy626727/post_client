import 'package:post_client/model/user/follow.dart';
import 'package:post_client/model/user/user.dart';

import '../../api/client/user/follow_api.dart';

class FollowService {
  static Future<Follow> followUser(
    int followeeId,
  ) async {
    var follow = await FollowApi.followUser(followeeId);
    return follow;
  }

  static Future<void> unfollowUser({
    required int followerId,
    required int followeeId,
  }) async {
    await FollowApi.unfollowUser(followeeId: followeeId, followerId: followerId);
  }

  static Future<List<User>> getFolloweeList(
    int pageIndex,
    int pageSize,
  ) async {
    var followeeList = await FollowApi.getFolloweeList(pageIndex, pageSize);
    return followeeList;
  }

  static Future<List<User>> getFollowerList(
    int pageIndex,
    int pageSize,
  ) async {
    var followeeList = await FollowApi.getFollowerList(pageIndex, pageSize);
    return followeeList;
  }

  static Future<Follow?> getFollow({
    required int followerId,
    required int followeeId,
  }) async {
    var follow = await FollowApi.getFollow(followerId: followerId, followeeId: followeeId);
    if (follow.id == 0) {
      return null;
    }
    return follow;
  }
}
