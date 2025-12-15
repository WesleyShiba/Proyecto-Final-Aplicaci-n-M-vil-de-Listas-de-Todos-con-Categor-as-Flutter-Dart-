import 'package:flutter/foundation.dart';
import '../models/todo_category.dart';
import '../models/todo_item.dart';

class TodoProvider with ChangeNotifier {
  final List<TodoCategory> _categories = [];

  List<TodoCategory> get categories => List.unmodifiable(_categories);

  TodoCategory? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  // CRUD Categorías
  void addCategory(String name) {
    _categories.add(
      TodoCategory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
      ),
    );
    notifyListeners();
  }

  void updateCategory(String id, String newName) {
    final category = getCategoryById(id);
    if (category != null) {
      category.name = newName;
      notifyListeners();
    }
  }

  void deleteCategory(String id) {
    _categories.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // CRUD Todos
  void addTodo(String categoryId, String title, DateTime? dueDate) {
    final category = getCategoryById(categoryId);
    if (category != null) {
      category.todos.add(
        TodoItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          dueDate: dueDate,
        ),
      );
      notifyListeners();
    }
  }

  void updateTodo(
    String categoryId,
    String todoId, {
    String? title,
    DateTime? dueDate,
    bool? isDone,
  }) {
    final category = getCategoryById(categoryId);
    if (category == null) return;

    final todo = category.todos.firstWhere((t) => t.id == todoId);
    todo.title = title ?? todo.title;
    todo.dueDate = dueDate ?? todo.dueDate;
    if (isDone != null) todo.isDone = isDone;

    notifyListeners();
  }

  void deleteTodo(String categoryId, String todoId) {
    final category = getCategoryById(categoryId);
    category?.todos.removeWhere((t) => t.id == todoId);
    notifyListeners();
  }
}
