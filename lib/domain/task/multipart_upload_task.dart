import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import 'package:sqflite/sqflite.dart';

import '../../config/global.dart';
import '../../enums/upload_task.dart';

part 'multipart_upload_task.g.dart';

@JsonSerializable()
class MultipartUploadTask {
  int? id;
  String? srcPath; //文件原路径
  int? totalSize; //文件/文件夹下的文件的大小
  int uploadedSize = 0; //进度
  String? md5; //文件的MD5，文件夹为0
  int? status; //上传状态
  String? statusMessage; //状态
  DateTime? createTime;
  int? fileId;
  bool? private;


  @JsonKey(includeFromJson: false, includeToJson: false)
  List<int>? magicNumber;

  //额外业务信息
  int? userId; //上传状态
  String? fileName; //文件名
  int? mediaType;

  MultipartUploadTask();

  MultipartUploadTask.file({
    required this.srcPath,
    this.fileName,
    this.userId,
    this.private,
    this.status = UploadTaskStatus.uploading,
    this.uploadedSize = 0,
  });

  void copy(MultipartUploadTask task) {
    id = task.id;
    fileName = task.fileName;
    srcPath = task.srcPath;
    uploadedSize = task.uploadedSize;
    totalSize = task.totalSize;
    status = task.status;
    createTime = task.createTime;
    statusMessage = task.statusMessage;
    md5 = task.md5;
    fileId = task.fileId;
    magicNumber = task.magicNumber;
    private = task.private;
    mediaType = task.mediaType;
  }

  void clear() {
    id = null;
    fileName = null;
    srcPath = null;
    uploadedSize = 0;
    totalSize = null;
    status = null;
    createTime = null;
    statusMessage = null;
    md5 = null;
    fileId = null;
    magicNumber = null;
    private = null;
    mediaType = null;
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
