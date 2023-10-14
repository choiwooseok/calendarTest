import 'package:calendar_test/repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'view_model/expense_vm.dart';
import 'view_model/settings_vm.dart';
import 'repository/settings_repository.dart';

void main() async {
  final settingViewModel = SettingsViewModel(SettingsRepository());
  await settingViewModel.loadSettings();

  final expenseViewModel = ExpenseViewModel(ExpenseRepository());
  await expenseViewModel.loadExpenses();

  runApp(ChangeNotifierProvider(
    create: (_) => expenseViewModel,
    child: MyApp(settingsViewModel: settingViewModel),
  ));
}
