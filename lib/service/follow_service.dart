import 'package:post_client/config/global.dart';
import 'package:post_client/model/follow.dart';
import 'package:post_client/model/user.dart';

import '../api/client/user/follow_api.dart';

class FollowService {
  static Future<Follow> followUser(
    String followeeId,
  ) async {
    var follow = await FollowApi.followUser(followeeId);
    return follow;
  }

  static Future<void> unfollowUser(
    String followerId,
    String followeeId,
  ) async {
    await FollowApi.unfollowUser(followeeId: followeeId, followerId: followerId);
  }

  static Future<List<User>> getFolloweeList() async {
    var followeeList = await FollowApi.getFolloweeListByFollowerId(Global.user.id!);
    return followeeList;
  }

  static Future<List<User>> getFollowerList() async {
    var followeeList = await FollowApi.getFollowerListByFolloweeId(Global.user.id!);
    return followeeList;
  }

  static Future<Follow> getFollow({
    required int followerId,
    required int followeeId,
  }) async {
    var follow = await FollowApi.getFollow(followerId: followerId, followeeId: followeeId);
    return follow;
  }
}
