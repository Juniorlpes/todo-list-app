import 'package:todo_list/app/todo/data/models/todo_model.dart';
import 'package:todo_list/app/todo/domain/entities/todo_item.dart';
import 'package:todo_list/core/web_service/web_service.dart';

abstract class TodoDatasource {
  Future<List<TodoItemModel>> getAllTodos();
  Future<TodoItemModel> createOrUpdateTodo(TodoItem item);
  Future<void> deleteTodo(String id);
  Future<void> updateTodosListOrder(List<TodoItem> itens);
}

class TodoDatasourceImpl implements TodoDatasource {
  final WebService _todoRest;

  TodoDatasourceImpl(this._todoRest);

  @override
  Future<List<TodoItemModel>> getAllTodos() async {
    final result =
        await _todoRest.getList('/todo', (json) => TodoItemModel.fromMap(json));

    if (result.success) {
      return result.data;
    } else {
      throw result.failure!;
    }
  }

  @override
  Future<TodoItemModel> createOrUpdateTodo(TodoItem item) async {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTodo(String id) async {
    final result = await _todoRest.deleteModel('/todo/$id');

    if (result.success) {
      return;
    } else {
      throw result.failure!;
    }
  }

  @override
  Future<void> updateTodosListOrder(List<TodoItem> itens) async {
    final result = await _todoRest.putList(
      '/todo/all',
      itens,
      (json) => TodoItemModel.fromMap(json),
    );

    if (result.success) {
      return;
    } else {
      throw result.failure!;
    }
  }
}
