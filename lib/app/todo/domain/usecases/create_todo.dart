import 'package:todo_list/app/todo/domain/entities/todo_item.dart';
import 'package:todo_list/core/utils/base_usecases.dart';
import 'package:todo_list/core/utils/typedefs.dart';

import '../repositories/todo_repository.dart';

class CreateTodo extends UsecaseWithParams<TodoItem, TodoItem> {
  final TodoRepository _repository;

  CreateTodo(this._repository);

  @override
  FutureEitherResult<TodoItem> call(TodoItem params) async {
    return await _repository.createTodo(params);
  }
}
