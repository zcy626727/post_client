import 'package:json_annotation/json_annotation.dart';

import '../../enums/upload_task.dart';

part 'single_upload_task.g.dart';

/// 上传任务（文件/文件夹）
/// 文件：
/// 文件夹：
@JsonSerializable()
class SingleUploadTask {
  int? id;
  String? srcPath; //文件原路径
  int? totalSize; //文件/文件夹下的文件的大小
  int uploadedSize = 0; //进度
  String? md5; //文件的MD5
  int? fileId;
  bool? private;
  String? statusMessage; //文件的MD5
  int? status; //上传状态
  DateTime? createTime;

  //额外属性
  String? coverUrl;
  int? mediaType;

  SingleUploadTask();

  SingleUploadTask.file({
    required this.srcPath,
    this.private,
    this.status = UploadTaskStatus.uploading,
    this.uploadedSize = 0,
  });

  void copy(SingleUploadTask task) {
    id = task.id;
    srcPath = task.srcPath;
    uploadedSize = task.uploadedSize;
    totalSize = task.totalSize;
    status = task.status;
    mediaType = task.mediaType;
    createTime = task.createTime;
    statusMessage = task.statusMessage;
    md5 = task.md5;
    fileId = task.fileId;
    private = task.private;
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
    fileId = null;
    private = null;
  }

  factory SingleUploadTask.fromJson(Map<String, dynamic> json) => _$SingleUploadTaskFromJson(json);

  Map<String, dynamic> toJson() => _$SingleUploadTaskToJson(this);
}
