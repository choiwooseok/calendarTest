import 'package:flutter/material.dart';

import 'expense_item.dart';

class ExpenseItems with ChangeNotifier {
  final List<Expense> _expenses = List.empty(growable: true);
  List<Expense> _filteredExpenses = [];

  List<Expense> get filteredExpenses => _filteredExpenses;

  void addExpense(Expense expense) {
    _expenses.add(expense);
    filterByDate(_filteredExpenses.isNotEmpty
        ? _filteredExpenses.first.date
        : DateTime.now());
    notifyListeners();
  }

  void deleteExpense(Expense expense) {
    _expenses.remove(expense);
    filterByDate(_filteredExpenses.isNotEmpty
        ? _filteredExpenses.first.date
        : DateTime.now());
    notifyListeners();
  }

  void filterByDate(DateTime date) {
    _filteredExpenses =
        _expenses.where((expense) => expense.date.day == date.day).toList();
    notifyListeners();
  }
}
