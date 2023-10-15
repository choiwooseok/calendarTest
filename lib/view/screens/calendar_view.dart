import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'add_event_view.dart';
import '../../view_model/events_vm.dart';

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
    final eventsViewModel = Provider.of<EventsViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Tracker'),
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
            'Total Sum : ${eventsViewModel.accumulateEventsByMonth(_selectedDay!)}',
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
              eventsViewModel.filterByDate(selectedDay);
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) => eventsViewModel.getEventsByDate(day),
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
              itemCount: eventsViewModel.filteredEvents.length,
              itemBuilder: (context, index) {
                final event = eventsViewModel.filteredEvents[index];
                return ListTile(
                  title: Text(event.name),
                  subtitle: Text(event.amount.toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => eventsViewModel.deleteEvent(event),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newEvent = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEventView(_selectedDay),
            ),
          );
          if (newEvent != null) {
            eventsViewModel.addEvent(newEvent);
            _selectedDay = newEvent.date;
            eventsViewModel.filterByDate(_selectedDay!);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
