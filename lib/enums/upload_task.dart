class UploadTaskStatus {
  static const int init = 1;
  static const int uploading = 2;
  static const int awaiting = 3;
  static const int pause = 4;
  static const int finished = 5;
  static const int error = 6;
}

class TaskType {
  static const int file = 1;
  static const int folder = 2;
}