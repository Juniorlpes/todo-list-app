// ignore_for_file: overridden_fields

import 'package:hive/hive.dart';
import 'package:todo_list/app/todo/domain/entities/todo_item.dart';
import 'package:todo_list/core/cache/cache_adapters_id.dart';

part 'todo_model.g.dart';

@HiveType(typeId: CacheAdaptersId.todoModelAdapter)
class TodoItemModel extends TodoItem {
  @override
  @HiveField(0)
  final String id;

  @override
  @HiveField(1)
  String todo;

  @override
  @HiveField(2)
  int order;

  @override
  @HiveField(3)
  bool done;

  TodoItemModel({
    required this.id,
    required this.todo,
    required this.order,
    this.done = false,
  }) : super(todo: todo, order: order, id: id, done: done);

  factory TodoItemModel.fromItem(TodoItem item) => TodoItemModel(
        id: item.id,
        todo: item.todo,
        order: item.order,
        done: item.done,
      );
}
