import 'package:json_annotation/json_annotation.dart';
import 'package:post_client/domain/task/upload_task.dart';

import '../../constant/file/upload.dart';

part 'single_upload_task.g.dart';

/// 上传任务（文件/文件夹）
/// 文件：
/// 文件夹：
@JsonSerializable()
class SingleUploadTask extends UploadTask {
  String? coverUrl;
  int? mediaType;

  SingleUploadTask();

  SingleUploadTask.file({
    required srcPath,
    private,
    status = UploadTaskStatus.uploading,
  }) : super(srcPath: srcPath, private: private, status: status);

  void copy(SingleUploadTask task) {
    super.copyField(task);
    mediaType = task.mediaType;
    coverUrl = task.coverUrl;
  }

  @override
  void clear() {
    super.clear();
    coverUrl = null;
    mediaType = null;
  }

  factory SingleUploadTask.fromJson(Map<String, dynamic> json) => _$SingleUploadTaskFromJson(json);

  Map<String, dynamic> toJson() => _$SingleUploadTaskToJson(this);
}
