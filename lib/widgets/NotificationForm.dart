import 'package:flutter/material.dart';
import '../services/notifications.dart';
import 'package:on_the_go_reminder/views/todo_screen.dart';

class NotificationForm extends StatefulWidget {
  const NotificationForm({Key? key}) : super(key: key);

  @override
  _NotificationFormState createState() => _NotificationFormState();
}

class _NotificationFormState extends State<NotificationForm> {
  Duration _selectedDuration = const Duration(minutes: 5);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select notification duration:'),
          DropdownButton<Duration>(
            value: _selectedDuration,
            onChanged: (Duration? value) {
              setState(() {
                _selectedDuration = value!;
              });
            },
            items: const [
              DropdownMenuItem(
                value: Duration(minutes: 5),
                child: Text('5 minutes'),
              ),
              DropdownMenuItem(
                value: Duration(minutes: 10),
                child: Text('10 minutes'),
              ),
              DropdownMenuItem(
                value: Duration(minutes: 15),
                child: Text('15 minutes'),
              ),
              DropdownMenuItem(
                value: Duration(minutes: 30),
                child: Text('30 minutes'),
              ),
              DropdownMenuItem(
                value: Duration(minutes: 60),
                child: Text('1 hour'),
              ),
              DropdownMenuItem(
                value: Duration(minutes: 1440),
                child: Text('1 day'),
              ),
              // Add additional duration options as needed
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                LocalNotificationsService().showScheduledNotification(
                  id: 0,
                  title: 'On the Go Reminder',
                  body: 'This is your reminder to do your tasks!',
                  duration: _selectedDuration,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ToDoScreen()),
                );
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
