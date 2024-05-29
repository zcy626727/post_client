import 'package:intl/intl.dart';

class DateTimeUtil {
  //时间格式化
  static String durationTimeFormat(Duration d) {
    var timeStr = d.toString();
    int start = 0;
    int end = timeStr.lastIndexOf(".");
    int width = 8;
    if (d.inHours == 0) {
      //小于一小时只显示分钟和秒
      start = timeStr.indexOf(":") + 1;
      width = 5;
    } else if (d.inHours < 24) {
      width = 8;
    } else {
      //超过24小时
      return timeStr;
    }
    return timeStr.substring(start, end).padLeft(width, "0");
  }

  static String durationZeroTimeFormat(bool hasHour) {
    if (hasHour) {
      return "00:00:00";
    } else {
      return "00:00";
    }
  }

  static String unknownTimeFormat() {
    return "--";
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss").format(dateTime);
  }

  static String formatDate(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd").format(dateTime);
  }

  static String formatRFC3339(DateTime date) {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSSSS+00:00").format(DateTime.parse(date.toString()).toUtc());
  }
}
