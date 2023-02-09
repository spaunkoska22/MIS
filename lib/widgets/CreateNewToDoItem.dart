import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';
import 'package:on_the_go_reminder/models/ToDoItem.dart';

class CreateNewToDoItem extends StatefulWidget {
  final Function addNewToDoItem;

  CreateNewToDoItem(this.addNewToDoItem);

  @override
  State<StatefulWidget> createState() => _CreateNewToDoItemState();
}

class _CreateNewToDoItemState extends State<CreateNewToDoItem> {
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();

  void _submitData() {
    if (_titleController.text.isEmpty || _dateController.text.isEmpty) {
      return;
    }

    int check1 = '-'.allMatches(_dateController.text).length;
    int check2 = ':'.allMatches(_dateController.text).length;

    if (_dateController.text.length < 16 || check1 != 2 || check2 != 1) {
      print("Please enter date in the right format!");
      return;
    }

    final String stringDate = _dateController.text + ':00';
    DateTime date = DateTime.parse(stringDate);

    final newToDoItem = ToDoItem(
      id: nanoid(5),
      title: _titleController.text,
      date: date,
    );
    widget.addNewToDoItem(newToDoItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(labelText: "To-Do Item"),
            controller: _titleController,
            onSubmitted: (_) => _submitData(),
          ),
          TextField(
            decoration: const InputDecoration(
                labelText: "Deadline (ex. 2022-05-10 10:00)"),
            controller: _dateController,
            onSubmitted: (_) => _submitData(),
          ),
        ],
      ),
    );
  }
}
