import 'package:todo_list/app/todo/domain/entities/todo_item.dart';
import 'package:todo_list/app/todo/domain/repositories/todo_repository.dart';
import 'package:todo_list/core/utils/base_usecases.dart';
import 'package:todo_list/core/utils/typedefs.dart';

class GetTodosList extends Usecase<List<TodoItem>> {
  final TodoRepository _repository;

  GetTodosList(this._repository);

  @override
  FutureEitherResult<List<TodoItem>> call() async {
    return await _repository.getAllTodosList();
  }
}
