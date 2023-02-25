class ToDoItem {
  final String id;
  final String title;
  final DateTime date;
  final String location;
  final int priority;

  ToDoItem({required this.id, required this.title, required this.date, required this.location, this.priority = 0});
}
