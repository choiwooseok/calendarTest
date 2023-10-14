import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'add_expense_view.dart';
import '../../view_model/expense_vm.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  static const routeName = '/';

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final expenseViewModel = Provider.of<ExpenseViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Text(
            'Total Outcome : ${expenseViewModel.accumulateExpensesByMonth(_selectedDay!)}',
          ),
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
              expenseViewModel.filterByDate(selectedDay);
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) => expenseViewModel.getExpensesByDate(day),
            calendarBuilders: CalendarBuilders(
              singleMarkerBuilder: (context, date, _) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  width: 10,
                  height: 10,
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expenseViewModel.filteredExpenses.length,
              itemBuilder: (context, index) {
                final expense = expenseViewModel.filteredExpenses[index];
                return ListTile(
                  title: Text(expense.name),
                  subtitle: Text(expense.amount.toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => expenseViewModel.deleteExpense(expense),
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
            expenseViewModel.addExpense(newExpense);
            _selectedDay = newExpense.date;
            expenseViewModel.filterByDate(_selectedDay!);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
