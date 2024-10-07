import 'package:todo_list/app/todo/data/models/todo_model.dart';
import 'package:todo_list/app/todo/domain/entities/todo_item.dart';

abstract class TodoLocalDatasource {
  Future<List<TodoItemModel>> getAllTodos();
  Future<TodoItemModel> createOrUpdateTodo(TodoItem item);
  Future<void> deleteTodo(String id);
  Future<void> updateTodosListOrder(List<TodoItem> itens);
}

class TodoLocalDatasourceImpl implements TodoLocalDatasource {
  TodoLocalDatasourceImpl();

  @override
  Future<List<TodoItemModel>> getAllTodos() async {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<TodoItemModel> createOrUpdateTodo(TodoItem item) async {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTodo(String id) async {
    // TODO: implement
    throw UnimplementedError();
  }

  @override
  Future<void> updateTodosListOrder(List<TodoItem> itens) async {
    // TODO: implement
    throw UnimplementedError();
  }
}
