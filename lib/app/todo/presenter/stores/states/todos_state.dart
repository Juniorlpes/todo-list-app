import '../../../../../core/general_app_failure.dart';
import '../../../domain/entities/todo_item.dart';

abstract class TodoListState {}

class LoadingTodosState extends TodoListState {}

class FailureTodosState extends TodoListState {
  GeneralAppFailure failure;

  FailureTodosState(this.failure);
}

class SuccessTodosFailure extends TodoListState {
  List<TodoItem> todosItens; //final?

  SuccessTodosFailure(this.todosItens);
}
