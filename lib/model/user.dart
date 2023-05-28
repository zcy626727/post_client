import 'package:json_annotation/json_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    this.id,
    this.phoneNumber,
    this.lastLoginTime,
    this.token,
    this.avatarUrl,
    this.name,
    this.themeMode = 0,
    this.blacklistNumber,
    this.followerNumber,
    this.followNumber,
  });

  String? phoneNumber;
  int? id;
  String? name;

  String? token;
  String? lastLoginTime;
  String? avatarUrl;

  //粉丝
  int? followerNumber;

  //关注
  int? followNumber;

  //拉黑
  int? blacklistNumber;

  //0：跟随系统，1：亮，2：暗
  int? themeMode = 0;

  static String createSql = '''
    create table user ( 
      id integer primary key autoincrement, 
      name text not null,
      token text,
      lastLoginTime text not null,
      phoneNumber text not null,
      avatarUrl text,
      themeMode integer not null,
      followerNumber integer,
      followNumber integer,
      blacklistNumber integer
    )
  ''';

  String formatId() {
    if (id != null) {
      return "$id".padLeft(10, "0");
    } else {
      return "";
    }
  }

  void clearUserInfo() {
    name = null;
    phoneNumber = null;
    token = null;
    id = null;
    avatarUrl = null;
    themeMode = 0;
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

class UserProvider {
  late Database db;

  Future<User> insertOrUpdate(User user) async {
    user.id = await db.insert(
      "user",
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return user;
  }

  Future<User?> getUserByPhoneNumber(String phoneNumber) async {
    List<Map<String, Object?>> maps = await db.query(
      "user",
      columns: [
        "id",
        "name",
        "phoneNumber",
        "token",
        "avatarUrl",
        "lastLoginTime",
        "themeMode",
        "followerNumber",
        "followNumber",
        "blacklistNumber",
      ],
      where: 'phoneNumber = ?',
      whereArgs: [phoneNumber],
    );
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  Future<User?> getRecentUser() async {
    List<Map<String, Object?>> maps = await db.query(
      "user",
      columns: [
        "id",
        "name",
        "phoneNumber",
        "token",
        "avatarUrl",
        "lastLoginTime",
        "themeMode",
        "followerNumber",
        "followNumber",
        "blacklistNumber",
      ],
      orderBy: "lastLoginTime desc",
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete("user", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(User user) async {
    return await db
        .update("user", user.toJson(), where: 'id = ?', whereArgs: [user.id]);
  }
}
