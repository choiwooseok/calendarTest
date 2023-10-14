import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../utils/path_util.dart';

class SettingsRepository {
  Future<ThemeMode> themeMode() async {
    File config = File('${PathUtil.getAppSupportPath()}/config.json');

    if (config.existsSync()) {
      String configContent = config.readAsStringSync();
      var json = jsonDecode(configContent);
      String theme = json['themeMode'];

      if (theme == 'light') {
        return ThemeMode.light;
      } else if (theme == 'dark') {
        return ThemeMode.dark;
      } else if (theme == 'system') {
        return ThemeMode.system;
      }
    } else {
      config.createSync(recursive: true);
      config.writeAsStringSync('{"themeMode": "system"}');
    }

    return ThemeMode.system;
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    File config = File('${PathUtil.getAppSupportPath()}/config.json');

    switch (theme) {
      case ThemeMode.light:
        config.writeAsStringSync('{"themeMode": "light"}');
        break;
      case ThemeMode.dark:
        config.writeAsStringSync('{"themeMode": "dark"}');
        break;
      case ThemeMode.system:
        config.writeAsStringSync('{"themeMode": "system"}');
        break;
    }
  }
}
