import 'package:todo_list/app/todo/domain/entities/todo_item.dart';

class TodoItemModel extends TodoItem {
  TodoItemModel({
    required super.id,
    required super.todo,
    required super.order,
    super.done = false,
  });

  factory TodoItemModel.fromItem(TodoItem item) => TodoItemModel(
        id: item.id,
        todo: item.todo,
        order: item.order,
        done: item.done,
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'todo': todo,
      'order': order,
      'done': done,
    };
  }

  factory TodoItemModel.fromMap(Map<String, dynamic> map) {
    return TodoItemModel(
      id: map['id'] as String,
      todo: map['todo'] as String,
      order: map['order'] as int,
      done: map['done'] as bool,
    );
  }
}
