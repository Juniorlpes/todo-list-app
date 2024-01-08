import 'package:todo_list/app/todo/domain/entities/todo_item.dart';
import 'package:todo_list/app/todo/domain/repositories/todo_repository.dart';
import 'package:todo_list/core/utils/base_usecases.dart';
import 'package:todo_list/core/utils/typedefs.dart';

class UpdateTodo extends UsecaseWithParams<TodoItem, TodoItem> {
  final TodoRepository _repository;

  UpdateTodo(this._repository);

  @override
  FutureEitherResult<TodoItem> call(TodoItem params) async {
    return await _repository.updateTodo(params);
  }
}
