import 'package:post_client/config/global.dart';
import 'package:post_client/model/follow.dart';
import 'package:post_client/model/user.dart';

import '../user_http_config.dart';

class FollowApi {
  static Future<Follow> followUser(String followeeId) async {
    var r = await UserHttpConfig.dio.post(
      "/follow/followUser",
      data: {
        "followeeId": followeeId,
      },
      options: UserHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    return Follow.fromJson(r.data['follow']);
  }

  static Future<void> unfollowUser({
    required String followerId,
    required String followeeId,
  }) async {
    var r = await UserHttpConfig.dio.post(
      "/follow/unfollowUser",
      data: {
        "followeeId": followeeId,
        "followerId": followerId,
      },
      options: UserHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
  }

  //获取我关注的列表
  static Future<List<User>> getFolloweeListByFollowerId(int followerId) async {
    var r = await UserHttpConfig.dio.get(
      "/follow/getFolloweeListByFollowerId",
      data: {"followerId": Global.user.id},
      options: UserHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    List<User> followeeList = [];
    for (var followeeJson in r.data['followeeList']) {
      var followee = User.fromJson(followeeJson);
      followeeList.add(followee);
    }
    return followeeList;
  }

  //获取关注我的列表
  static Future<List<User>> getFollowerListByFolloweeId(int followerId) async {
    var r = await UserHttpConfig.dio.get(
      "/follow/getFollowerListByFolloweeId",
      data: {"followerId": Global.user.id},
      options: UserHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );
    List<User> followerList = [];
    for (var followerJson in r.data['followerList']) {
      var follower = User.fromJson(followerJson);
      followerList.add(follower);
    }
    return followerList;
  }

  //获取两人的关注关系
  static Future<Follow> getFollow({
    required int followerId,
    required int followeeId,
  }) async {
    var r = await UserHttpConfig.dio.get(
      "/follow/getFollowerListByFolloweeId",
      data: {"followerId": followerId, "followeeId": followeeId},
      options: UserHttpConfig.options.copyWith(extra: {
        "noCache": true,
        "withToken": true,
      }),
    );

    return Follow.fromJson(r.data['follow']);
  }
}
