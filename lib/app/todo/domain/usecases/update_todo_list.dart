import 'package:todo_list/app/todo/domain/entities/todo_item.dart';
import 'package:todo_list/app/todo/domain/repositories/todo_repository.dart';
import 'package:todo_list/core/utils/base_usecases.dart';
import 'package:todo_list/core/utils/typedefs.dart';

class UpdateTodoList extends UsecaseWithParams<void, List<TodoItem>> {
  final TodoRepository _repository;

  UpdateTodoList(this._repository);

  @override
  FutureEitherResult<void> call(List<TodoItem> params) async {
    return await _repository.updateTodoListOrder(params);
  }
}
