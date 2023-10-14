import 'package:flutter/material.dart';

import '../model/expense_item.dart';
import '../repository/expense_repository.dart';

class ExpenseViewModel with ChangeNotifier {
  ExpenseViewModel(this._expenseRepository);

  final ExpenseRepository _expenseRepository;

  late List<Expense> _expenses;

  List<Expense> get expenses => _expenses;

  List<Expense> _filteredExpenses = [];
  List<Expense> get filteredExpenses => _filteredExpenses;

  Future<void> loadExpenses() async {
    _expenses = await _expenseRepository.getExpenses();
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    _expenses = await _expenseRepository.addExpense(expense);
    filterByDate(_filteredExpenses.isNotEmpty
        ? _filteredExpenses.first.date
        : DateTime.now());
    notifyListeners();
  }

  Future<void> deleteExpense(Expense expense) async {
    _expenses = await _expenseRepository.deleteExpense(expense);
    filterByDate(_filteredExpenses.isNotEmpty
        ? _filteredExpenses.first.date
        : DateTime.now());
    notifyListeners();
  }

  void filterByDate(DateTime date) {
    _filteredExpenses = _expenses
        .where((expense) =>
            expense.date.year == date.year &&
            expense.date.month == date.month &&
            expense.date.day == date.day)
        .toList();
    notifyListeners();
  }

  List<Expense> getExpensesByDate(DateTime date) {
    return _expenses
        .where((expense) =>
            expense.date.year == date.year &&
            expense.date.month == date.month &&
            expense.date.day == date.day)
        .toList();
  }

  double accumulateExpensesByMonth(DateTime date) {
    return _expenses
        .where((expense) =>
            expense.date.year == date.year && expense.date.month == date.month)
        .map((e) => e.amount)
        .fold(0, (previousValue, element) => previousValue + element);
  }
}
