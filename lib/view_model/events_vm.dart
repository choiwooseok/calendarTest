import 'package:flutter/material.dart';

import '../model/event.dart';
import '../repository/events_repository.dart';

class EventsViewModel with ChangeNotifier {
  EventsViewModel(this._eventRepository);

  final EventsRepository _eventRepository;

  late List<Event> _events;

  List<Event> get events => _events;

  List<Event> _filteredEvents = [];
  List<Event> get filteredEvents => _filteredEvents;

  Future<void> loadEvents() async {
    _events = await _eventRepository.getEvents();
    notifyListeners();
  }

  Future<void> addEvent(Event event) async {
    _events = await _eventRepository.addEvent(event);
    filterByDate(_filteredEvents.isNotEmpty
        ? _filteredEvents.first.date
        : DateTime.now());
    notifyListeners();
  }

  Future<void> deleteEvent(Event event) async {
    _events = await _eventRepository.deleteEvent(event);
    filterByDate(_filteredEvents.isNotEmpty
        ? _filteredEvents.first.date
        : DateTime.now());
    notifyListeners();
  }

  void filterByDate(DateTime date) {
    _filteredEvents = _events
        .where((event) =>
            event.date.year == date.year &&
            event.date.month == date.month &&
            event.date.day == date.day)
        .toList();
    notifyListeners();
  }

  List<Event> getEventsByDate(DateTime date) {
    return _events
        .where((event) =>
            event.date.year == date.year &&
            event.date.month == date.month &&
            event.date.day == date.day)
        .toList();
  }

  double accumulateEventsByMonth(DateTime date) {
    return _events
        .where((event) =>
            event.date.year == date.year && event.date.month == date.month)
        .map((e) => e.amount)
        .fold(0, (previousValue, element) => previousValue + element);
  }
}
