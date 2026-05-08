import 'package:flutter/foundation.dart';
import 'package:todo_list/app/todo/data/models/todo_model.dart';
import 'package:todo_list/app/todo/domain/entities/todo_item.dart';
import 'package:todo_list/app/todo/domain/repositories/todo_repository.dart';

import 'package:todo_list/app/todo/presenter/stores/states/todos_state.dart';

export 'package:todo_list/app/todo/presenter/stores/states/todos_state.dart';

class TodosListStore extends ValueNotifier<TodoListState> {
  final TodoRepository _repository;

  TodosListStore(this._repository) : super(LoadingTodosState()) {
    getAllTodoItens();
  }

  List<TodoItem>? get _currentTodos => value is SuccessTodosState
      ? (value as SuccessTodosState).todosItens
      : null;

  Future<void> getAllTodoItens() async {
    value = LoadingTodosState();

    final result = await _repository.getAllTodosList();

    result.fold(
      (l) => value = FailureTodosState(l),
      (r) => value = SuccessTodosState(r),
    );
  }

  void updateTodo(TodoItem item) {
    final todos = _currentTodos;
    if (todos == null) return;

    final idx = todos.indexOf(item);
    if (idx == -1) return;

    todos[idx] = item;
    notifyListeners();

    _repository.updateTodo(item);
  }

  void createTodo(TodoItem item) {
    final todos = _currentTodos;
    if (todos == null) return;

    todos.add(TodoItemModel.fromItem(item));
    notifyListeners();

    _repository.createTodo(item);
  }

  void deleteTodo(TodoItem item) {
    final todos = _currentTodos;
    if (todos == null) return;

    todos.remove(item);
    notifyListeners();

    _repository.deleteTodo(item.id).then((_) => _updateTodosOrders());
  }

  void reorder(int oldIndex, int newIndex) {
    final todos = _currentTodos;
    if (todos == null) return;

    final newIdx = (oldIndex > newIndex) ? newIndex : newIndex - 1;
    todos.insert(newIdx, todos.removeAt(oldIndex));

    _updateTodosOrders();
  }

  void _updateTodosOrders() {
    final todos = _currentTodos;
    if (todos == null) return;

    for (var i = 0; i < todos.length; i++) {
      todos[i] = todos[i].copyWith(order: i);
    }

    notifyListeners();

    _repository.updateTodoListOrder(todos);
  }
}
