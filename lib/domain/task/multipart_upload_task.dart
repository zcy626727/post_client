import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/domain/task/upload_task.dart';
import 'package:sqflite/sqflite.dart';

import '../../config/global.dart';
import '../../constant/file/upload.dart';

part 'multipart_upload_task.g.dart';

@JsonSerializable()
class MultipartUploadTask extends UploadTask {
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<int>? magicNumber;

  int? userId; //上传状态
  String? fileName; //文件名
  int? mediaType;

  MultipartUploadTask();

  MultipartUploadTask.file({
    required srcPath,
    this.fileName,
    this.userId,
    private,
    status = UploadTaskStatus.uploading,
  }) : super(private: private, status: status, srcPath: srcPath);

  void copy(MultipartUploadTask task) {
    super.copyField(task);
    magicNumber = task.magicNumber;
    mediaType = task.mediaType;
    fileName = task.fileName;
    userId = task.userId;
  }

  @override
  void clear() {
    super.clear();
    magicNumber = null;
    mediaType = null;
    fileName = null;
    userId = null;
  }

  factory MultipartUploadTask.fromJson(Map<String, dynamic> json) => _$MultipartUploadTaskFromJson(json);

  Map<String, dynamic> toJson() => _$MultipartUploadTaskToJson(this);
}

class UploadTaskProvider {
  late Database db;

  static String createSql = '''
    create table multipartUploadTask ( 
      id integer primary key autoincrement, 
      fileName text not null,
      srcPath text not null,
      totalSize integer not null,
      uploadedSize integer not null,
      status integer not null,
      fileId integer not null,
      createTime text not null,
      md5 text not null,
      mediaType text,
      statusMessage text,
      private bool,
      userId integer
    )
  ''';

  //何时调用：任务刚添加、任务上传完毕、任务出错、更新已上传分片数
  Future<MultipartUploadTask> insertOrUpdate(MultipartUploadTask task) async {
    task.id = await db.insert(
      "multipartUploadTask",
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return task;
  }

  Future<void> delete(MultipartUploadTask task) async {
    if (task.id == null) {
      log('task.id为null');
      return;
    }
    task.id = await db.delete(
      "multipartUploadTask",
      where: "id=?",
      whereArgs: [task.id],
    );
  }

  Future<List<MultipartUploadTask>> getAllTaskList() async {
    var user = Global.user;
    if (user.id == null || user.id == 0) {
      return <MultipartUploadTask>[];
    }
    List<Map<String, Object?>> mapList = await db.query(
      "multipartUploadTask",
      where: "userId=?",
      whereArgs: [user.id],
      orderBy: "createTime",
    );
    List<MultipartUploadTask> list = [];
    for (var map in mapList) {
      list.add(MultipartUploadTask.fromJson(map));
    }
    return list;
  }
}
