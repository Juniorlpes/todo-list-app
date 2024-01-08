import 'package:todo_list/app/todo/domain/repositories/todo_repository.dart';
import 'package:todo_list/core/utils/base_usecases.dart';
import 'package:todo_list/core/utils/typedefs.dart';

class DeleteTodo extends UsecaseWithParams<void, String> {
  final TodoRepository _repository;

  DeleteTodo(this._repository);

  @override
  FutureEitherResult<void> call(String params) async =>
      await _repository.deleteTodo(params);
}
