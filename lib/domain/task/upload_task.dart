class UploadTask {
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

  UploadTask({this.id, this.srcPath, this.totalSize, this.uploadedSize = 0, this.md5, this.fileId, this.private, this.statusMessage, this.status, this.createTime});

  void clear() {
    id = null;
    srcPath = null;
    uploadedSize = 0;
    totalSize = null;
    status = null;
    createTime = null;
    statusMessage = null;
    md5 = null;
    fileId = null;
    private = null;
  }

  void copyField(UploadTask task) {
    id = task.id;
    srcPath = task.srcPath;
    uploadedSize = task.uploadedSize;
    totalSize = task.totalSize;
    status = task.status;
    createTime = task.createTime;
    statusMessage = task.statusMessage;
    md5 = task.md5;
    fileId = task.fileId;
    private = task.private;
  }
}
