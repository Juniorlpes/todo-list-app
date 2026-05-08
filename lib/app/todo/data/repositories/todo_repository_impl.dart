import 'package:todo_list/app/todo/data/datasources/todo_datasource.dart';
import 'package:todo_list/app/todo/domain/entities/todo_item.dart';
import 'package:todo_list/core/app_failure.dart';
import 'package:todo_list/core/utils/either.dart';

import 'package:todo_list/core/utils/typedefs.dart';

import '../../domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoDatasource _localDatasource;

  TodoRepositoryImpl(this._localDatasource);

  @override
  FutureEitherResult<TodoItem> createTodo(TodoItem item) async {
    try {
      return right(await _localDatasource.createOrUpdateTodo(item));
    } catch (e) {
      return left(
          e is AppFailure ? e : UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  FutureEitherResult<TodoItem> updateTodo(TodoItem item) async {
    return await createTodo(item);
  }

  @override
  FutureEitherResult<void> deleteTodo(String id) async {
    try {
      return right(await _localDatasource.deleteTodo(id));
    } catch (e) {
      return left(
          e is AppFailure ? e : UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  FutureEitherResult<List<TodoItem>> getAllTodosList() async {
    try {
      final allLocal = await _localDatasource.getAllTodos();
      return right(allLocal..sort());
    } catch (e) {
      return left(
          e is AppFailure ? e : UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  FutureEitherResult<void> updateTodoListOrder(List<TodoItem> itens) async {
    try {
      return right(await _localDatasource.updateTodosListOrder(itens));
    } catch (e) {
      return left(
          e is AppFailure ? e : UnexpectedFailure(message: e.toString()));
    }
  }
}
