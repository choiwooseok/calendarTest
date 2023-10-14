import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/path_util.dart';

class SettingsRepository {
  Future<ThemeMode> themeMode() async {
    if (kIsWeb) {
      return ThemeMode.system;
    }

    File config = File('${PathUtil.getAppSupportPath()}/config.json');

    if (config.existsSync() == false) {
      config.createSync(recursive: true);
      config.writeAsStringSync('{"themeMode": "system"}');
    }

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

    return ThemeMode.system;
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    if (kIsWeb) {
      return;
    }

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
