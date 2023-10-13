import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/expense_feature/expense_items.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();

  runApp(ChangeNotifierProvider(
    create: (_) => ExpenseItems(),
    child: MyApp(settingsController: settingsController),
  ));
}
