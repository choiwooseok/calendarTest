import '../model/expense_item.dart';

class ExpenseRepository {
  final List<Expense> _expenses = List.empty(growable: true);

  Future<List<Expense>> getExpenses() async {
    return _expenses;
  }

  Future<List<Expense>> addExpense(Expense expense) async {
    _expenses.add(expense);
    return _expenses;
  }

  Future<List<Expense>> deleteExpense(Expense expense) async {
    _expenses.remove(expense);
    return _expenses;
  }
}
