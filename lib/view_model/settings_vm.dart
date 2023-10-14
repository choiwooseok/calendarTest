import 'package:flutter/material.dart';

import '../repository/settings_repository.dart';

class SettingsViewModel with ChangeNotifier {
  SettingsViewModel(this._settingsRepository);

  final SettingsRepository _settingsRepository;

  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadSettings() async {
    _themeMode = await _settingsRepository.themeMode();

    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    if (newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;

    notifyListeners();

    await _settingsRepository.updateThemeMode(newThemeMode);
  }
}
