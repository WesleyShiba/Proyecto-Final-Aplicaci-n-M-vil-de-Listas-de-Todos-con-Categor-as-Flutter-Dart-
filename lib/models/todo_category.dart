import 'todo_item.dart';

class TodoCategory {
  final String id;
  String name;
  final List<TodoItem> todos;

  TodoCategory({
    required this.id,
    required this.name,
    List<TodoItem>? todos,
  }) : todos = todos ?? [];

  int get totalTodos => todos.length;
  int get completedTodos => todos.where((t) => t.isDone).length;
  int get pendingTodos => todos.where((t) => !t.isDone).length;
}
