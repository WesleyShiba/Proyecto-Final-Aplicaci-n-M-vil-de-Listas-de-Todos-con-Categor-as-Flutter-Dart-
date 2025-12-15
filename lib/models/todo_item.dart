class TodoItem {
  final String id;
  String title;
  bool isDone;
  DateTime? dueDate;

  TodoItem({
    required this.id,
    required this.title,
    this.isDone = false,
    this.dueDate,
  });
}
