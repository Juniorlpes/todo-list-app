import 'package:todo_list/app/todo/data/models/todo_model.dart';
import 'package:todo_list/app/todo/domain/entities/todo_item.dart';
import 'package:todo_list/core/cache/cache_controller.dart';

abstract class TodoLocalDatasource {
  Future<List<TodoItemModel>> getAllTodos();
  Future<TodoItemModel> createOrUpdateTodo(TodoItem item);
  Future<void> deleteTodo(String id);
  Future<void> updateTodosListOrder(List<TodoItem> itens);
}

class TodoLocalDatasourceImpl implements TodoLocalDatasource {
  final CacheController<TodoItemModel> _todoCacheController;

  TodoLocalDatasourceImpl(this._todoCacheController);

  @override
  Future<List<TodoItemModel>> getAllTodos() async {
    return (await _todoCacheController.values)?.toList() ?? [];
  }

  @override
  Future<TodoItemModel> createOrUpdateTodo(TodoItem item) async {
    final todo = TodoItemModel.fromItem(item);

    await _todoCacheController.writeByKey(item.id, todo);
    return todo;
  }

  @override
  Future<void> deleteTodo(String id) async {
    await _todoCacheController.deleteByKey(id);
  }

  @override
  Future<void> updateTodosListOrder(List<TodoItem> itens) async {
    await _todoCacheController.writeManyByKey(
      {
        for (var item in itens) item.id: TodoItemModel.fromItem(item),
      },
    );
  }
}
