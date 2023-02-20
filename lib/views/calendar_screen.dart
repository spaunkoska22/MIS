import 'package:flutter/material.dart';
import 'package:on_the_go_reminder/models/ToDoItem.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen(this._items, {super.key});

  final List<ToDoItem> _items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Calendar"),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        dataSource: MeetingDataSource(_getDataSource(_items)),
        monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        firstDayOfWeek: 1,
        showDatePickerButton: true,
      ),
    );
  }
}

List<ToDoItem> _getDataSource(List<ToDoItem> items) {
  final List<ToDoItem> reminders = items;
  return reminders;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<ToDoItem> source) {
    appointments = source;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].date;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].date;
  }
}
