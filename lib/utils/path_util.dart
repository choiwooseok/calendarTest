import 'dart:io';

class PathUtil {
  static String getAppSupportPath() {
    return '${Platform.environment['HOME']}/Library/Application Support/CalendarTests';
  }
}
