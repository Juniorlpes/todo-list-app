import 'package:todo_list/app/todo/data/models/todo_model.dart';
import 'package:todo_list/app/todo/domain/entities/todo_item.dart';
import 'package:todo_list/core/general_app_failure.dart';
import 'package:todo_list/core/rest_service/rest_service.dart';

abstract class TodoDatasource {
  Future<List<TodoItemModel>> getAllTodos();
  Future<TodoItemModel> createTodo(TodoItem item);
  Future<TodoItemModel> updateTodo(TodoItem item);
  Future<void> deleteTodo(String id);
  Future<void> updateTodosListOrder(List<TodoItem> itens);
}

class TodoDatasourceImpl implements TodoDatasource {
  final RestService _todoRest;

  TodoDatasourceImpl(this._todoRest);

  @override
  Future<List<TodoItemModel>> getAllTodos() async {
    final result =
        await _todoRest.getList('/todo', (json) => TodoItemModel.fromMap(json));

    if (result.success) {
      return result.data;
    } else {
      throw GeneralAppFailure()
        ..message = result.failure?.message
        ..statusCode = result.statusCode;
    }
  }

  @override
  Future<TodoItemModel> createTodo(TodoItem item) async {
    final result = await _todoRest.postModel(
      '/todo',
      TodoItemModel.fromItem(item).toMap(),
      (json) => TodoItemModel.fromMap(json),
    );

    if (result.success) {
      return result.data;
    } else {
      throw GeneralAppFailure()
        ..message = result.failure?.message
        ..statusCode = result.statusCode;
    }
  }

  @override
  Future<TodoItemModel> updateTodo(TodoItem item) async {
    final result = await _todoRest.putModel(
      '/todo',
      TodoItemModel.fromItem(item).toMap(),
      (json) => TodoItemModel.fromMap(json),
    );

    if (result.success) {
      return result.data;
    } else {
      throw GeneralAppFailure()
        ..message = result.failure?.message
        ..statusCode = result.statusCode;
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    final result = await _todoRest.deleteModel('/todo/$id');

    if (result.success) {
      return;
    } else {
      throw GeneralAppFailure()
        ..message = result.failure?.message
        ..statusCode = result.statusCode;
    }
  }

  @override
  Future<void> updateTodosListOrder(List<TodoItem> itens) async {
    final result = await _todoRest.putList(
      '/todo/all',
      itens.map((e) => TodoItemModel.fromItem(e).toMap()).toList(),
      (json) => TodoItemModel.fromMap(json),
    );

    if (result.success) {
      return;
    } else {
      throw GeneralAppFailure()
        ..message = result.failure?.message
        ..statusCode = result.statusCode;
    }
  }
}
