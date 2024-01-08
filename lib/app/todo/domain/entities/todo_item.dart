import 'package:todo_list/shared/utils/id_generator.dart';

class TodoItem implements Comparable<TodoItem> {
  late final String id;
  int order;
  String todo;
  bool done;

  TodoItem({
    required this.todo,
    required this.order,
    this.done = false,
    String? id,
  }) {
    this.id = id ?? getNewXid();
  }

  @override
  int compareTo(covariant TodoItem other) => order.compareTo(other.order);

  @override
  String toString() => 'TodoItem(todo: $todo, done: $done)';

  @override
  bool operator ==(covariant TodoItem other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode => todo.hashCode ^ done.hashCode ^ id.hashCode;
}
