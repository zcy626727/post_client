import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import 'package:sqflite/sqflite.dart';

import '../../config/global.dart';

part 'upload_task.g.dart';

/// 上传任务（文件/文件夹）
/// 文件：
/// 文件夹：
@JsonSerializable()
class UploadTask {
  int? id;
  int? userId;
  String? fileName; //文件名
  String? srcPath; //文件原路径
  int? resourceId; //上传项的id（文件/文件夹）
  int? totalSize; //文件/文件夹下的文件的大小
  int? uploadedSize; //进度
  String? md5; //文件的MD5，文件夹为0
  int? status; //上传状态
  String? statusMessage; //状态
  DateTime? createTime;

  int? taskParentFolderId; //上传任务中的文件夹id，上传文件夹时有效，否则为0
  int? parentId; //文件所在文件夹的id
  int? type; //文件/文件夹

  static String createSql = '''
    create table uploadTask ( 
      id integer primary key autoincrement, 
      userId integer not null, 
      fileName text not null,
      srcPath text not null,
      taskParentFolderId integer not null,
      resourceId integer,
      parentId integer not null,
      totalSize integer not null,
      uploadedSize integer not null,
      status integer not null,
      type integer not null,
      createTime text not null,
      md5 text not null,
      statusMessage text not null
    )
  ''';

  UploadTask();

  UploadTask.all({
    this.fileName,
    this.userId,
    this.srcPath,
    this.taskParentFolderId,
    this.parentId,
    this.uploadedSize,
    this.totalSize,
    this.status,
    this.type,
    this.createTime,
    this.md5,
  });

  void copy(UploadTask task) {
    id = task.id;
    userId = task.userId;
    resourceId = task.resourceId;
    fileName = task.fileName;
    srcPath = task.srcPath;
    taskParentFolderId = task.taskParentFolderId;
    parentId = task.parentId;
    uploadedSize = task.uploadedSize;
    totalSize = task.totalSize;
    status = task.status;
    type = task.type;
    createTime = task.createTime;
    statusMessage = task.statusMessage;
    md5 = task.md5;
  }

  factory UploadTask.fromJson(Map<String, dynamic> json) =>
      _$UploadTaskFromJson(json);

  Map<String, dynamic> toJson() => _$UploadTaskToJson(this);
}

enum UploadTaskStatus {
  //进行中任务的状态
  uploading, //上传阶段
  awaiting, //等待阶段
  pause, //暂停阶段
  finished, //完成阶段
  error, //上传出错
}

enum TaskType {
  folder,
  file,
}

class UploadTaskProvider {
  late Database db;

  //何时调用：任务刚添加、任务上传完毕、任务出错、更新已上传分片数
  Future<UploadTask> insertOrUpdate(UploadTask task) async {
    task.id = await db.insert(
      "uploadTask",
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return task;
  }

  Future<void> delete(UploadTask task) async {
    if (task.id == null) {
      log('task.id为null');
      return;
    }
    task.id = await db.delete(
      "uploadTask",
      where: "id=?",
      whereArgs: [task.id],
    );
  }

  Future<List<UploadTask>> getAllTaskList() async {
    var user = Global.user;
    if (user.id == null || user.id == 0) {
      return <UploadTask>[];
    }
    List<Map<String, Object?>> mapList = await db.query(
      "uploadTask",
      where: "userId=?",
      whereArgs: [user.id],
      orderBy: "createTime",
    );
    List<UploadTask> list = [];
    for (var map in mapList) {
      list.add(UploadTask.fromJson(map));
    }
    return list;
  }
}
