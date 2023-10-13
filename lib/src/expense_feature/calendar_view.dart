import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'add_expense_view.dart';
import 'expense_items.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  static const routeName = '/';

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final expenseList = Provider.of<ExpenseItems>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: Column(
        children: [
          TableCalendar(
            calendarFormat: CalendarFormat.month,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
            ),
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2021, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            daysOfWeekHeight: 30,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              expenseList.filterByDate(selectedDay);
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expenseList.filteredExpenses.length,
              itemBuilder: (context, index) {
                final expense = expenseList.filteredExpenses[index];
                return ListTile(
                  title: Text(expense.name),
                  subtitle: Text(expense.amount.toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => expenseList.deleteExpense(expense),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newExpense = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpenseView(_selectedDay),
            ),
          );
          if (newExpense != null) {
            expenseList.addExpense(newExpense);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
