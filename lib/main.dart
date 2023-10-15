import 'package:calendar_test/repository/events_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'view_model/events_vm.dart';
import 'view_model/settings_vm.dart';
import 'repository/settings_repository.dart';

void main() async {
  final settingViewModel = SettingsViewModel(SettingsRepository());
  await settingViewModel.loadSettings();

  final eventsViewModel = EventsViewModel(EventsRepository());
  await eventsViewModel.loadEvents();

  runApp(ChangeNotifierProvider(
    create: (_) => eventsViewModel,
    child: MyApp(settingsViewModel: settingViewModel),
  ));
}
