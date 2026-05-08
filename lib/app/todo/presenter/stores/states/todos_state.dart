import '../../../../../core/app_failure.dart';
import '../../../domain/entities/todo_item.dart';

abstract class TodoListState {}

class LoadingTodosState extends TodoListState {}

class FailureTodosState extends TodoListState {
  final AppFailure failure;

  FailureTodosState(this.failure);
}

class SuccessTodosState extends TodoListState {
  final List<TodoItem> todosItens;

  SuccessTodosState(this.todosItens);
}
