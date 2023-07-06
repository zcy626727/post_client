import 'dart:developer';
import 'dart:typed_data';

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
  String? srcPath; //文件原路径
  int? totalSize; //文件/文件夹下的文件的大小
  int uploadedSize = 0; //进度
  String? md5; //文件的MD5
  int? fileId;
  String? statusMessage; //文件的MD5
  int? status; //上传状态
  DateTime? createTime;
  int? mediaType;
  bool private = false;
  String? getUrl;
  String? staticUrl;
  List<int>? magicNumber;

  UploadMediaTask();

  UploadMediaTask.all({
    required this.srcPath,
    this.uploadedSize = 0,
    required this.totalSize,
    this.statusMessage,
    required this.status,
    required this.mediaType,
    this.createTime,
    this.md5,
    this.private = false,
    required this.magicNumber,
  });

  void copy(UploadMediaTask task) {
    id = task.id;
    srcPath = task.srcPath;
    uploadedSize = task.uploadedSize;
    totalSize = task.totalSize;
    status = task.status;
    mediaType = task.mediaType;
    createTime = task.createTime;
    statusMessage = task.statusMessage;
    md5 = task.md5;
    getUrl = task.getUrl;
    magicNumber = task.magicNumber;
    staticUrl = task.staticUrl;
    fileId = task.fileId;
  }

  void clear() {
    id = null;
    srcPath = null;
    uploadedSize = 0;
    totalSize = null;
    status = null;
    mediaType = null;
    createTime = null;
    statusMessage = null;
    md5 = null;
    getUrl = null;
    magicNumber = null;
    staticUrl = null;
    fileId = null;
  }

  factory UploadMediaTask.fromJson(Map<String, dynamic> json) => _$UploadMediaTaskFromJson(json);

  Map<String, dynamic> toJson() => _$UploadMediaTaskToJson(this);
}

enum UploadTaskStatus {
  init, //初始化阶段
  uploading, //上传中
  awaiting, //等待阶段
  pause, //暂停阶段
  finished, //完成阶段
  error, //上传出错
}

class MediaType {
  static const article = 1;
  static const image = 2;
  static const audio = 3;
  static const video = 4;
}
