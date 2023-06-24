import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import 'package:sqflite/sqflite.dart';

import '../../config/global.dart';

part 'upload_media_task.g.dart';

/// 上传任务（文件/文件夹）
/// 文件：
/// 文件夹：
@JsonSerializable()
class UploadMediaTask {
  int? id;
  String? fileName; //文件名
  String? srcPath; //文件原路径
  int? totalSize; //文件/文件夹下的文件的大小
  int? uploadedSize; //进度
  String? md5; //文件的MD5
  String? statusMessage; //文件的MD5
  int? status; //上传状态
  DateTime? createTime;
  int? mediaType;
  bool private = false;
  String? link;

  UploadMediaTask();

  UploadMediaTask.all({
    required this.fileName,
    required this.srcPath,
    this.uploadedSize,
    required this.totalSize,
    this.statusMessage,
    required this.status,
    required this.mediaType,
    this.createTime,
    this.md5,
    this.private=false,
  });

  void copy(UploadMediaTask task) {
    id = task.id;
    fileName = task.fileName;
    srcPath = task.srcPath;
    uploadedSize = task.uploadedSize;
    totalSize = task.totalSize;
    status = task.status;
    mediaType = task.mediaType;
    createTime = task.createTime;
    statusMessage = task.statusMessage;
    md5 = task.md5;
    link = task.link;
  }

  factory UploadMediaTask.fromJson(Map<String, dynamic> json) =>
      _$UploadMediaTaskFromJson(json);

  Map<String, dynamic> toJson() => _$UploadMediaTaskToJson(this);
}

enum UploadTaskStatus {
  init,//初始化阶段
  uploading, //上传中
  awaiting, //等待阶段
  pause, //暂停阶段
  finished, //完成阶段
  error, //上传出错
}

enum MediaType {
  image,
  audio,
  video,
}
