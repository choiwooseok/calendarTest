import '../model/event.dart';

class EventsRepository {
  final List<Event> _events = List.empty(growable: true);

  Future<List<Event>> getEvents() async {
    return _events;
  }

  Future<List<Event>> addEvent(Event expense) async {
    _events.add(expense);
    return _events;
  }

  Future<List<Event>> deleteEvent(Event expense) async {
    _events.remove(expense);
    return _events;
  }
}
