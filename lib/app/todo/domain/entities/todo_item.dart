import 'package:todo_list/shared/utils/id_generator.dart';

class TodoItem implements Comparable<TodoItem> {
  final String id;
  final int order;
  final String todo;
  final bool done;

  TodoItem({
    required this.todo,
    required this.order,
    this.done = false,
    String? id,
  }) : id = id ?? getNewXid();

  TodoItem copyWith({
    String? todo,
    int? order,
    bool? done,
  }) {
    return TodoItem(
      id: id,
      todo: todo ?? this.todo,
      order: order ?? this.order,
      done: done ?? this.done,
    );
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
