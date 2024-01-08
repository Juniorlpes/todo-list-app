import 'package:flutter/foundation.dart';
import 'package:todo_list/app/todo/data/models/todo_model.dart';
import 'package:todo_list/app/todo/domain/entities/todo_item.dart';
import 'package:todo_list/app/todo/domain/usecases/create_todo.dart';
import 'package:todo_list/app/todo/domain/usecases/delete_todo.dart';
import 'package:todo_list/app/todo/domain/usecases/get_todo_list.dart';
import 'package:todo_list/app/todo/domain/usecases/update_todo.dart';
import 'package:todo_list/app/todo/domain/usecases/update_todo_list.dart';

import 'package:todo_list/app/todo/presenter/stores/states/todos_state.dart';

export 'package:todo_list/app/todo/presenter/stores/states/todos_state.dart';

class TodosListStore extends ValueNotifier<TodoListState> {
  final CreateTodo _createTodo;
  final UpdateTodo _updateTodo;
  final DeleteTodo _deleteTodo;
  final GetTodosList _getTodosList;
  final UpdateTodoList _updateTodoList;

  TodosListStore(
    this._createTodo,
    this._updateTodo,
    this._deleteTodo,
    this._getTodosList,
    this._updateTodoList,
  ) : super(LoadingTodosState()) {
    getAllTodoItens();
  }

  Future<void> getAllTodoItens() async {
    value = LoadingTodosState();

    final result = await _getTodosList();

    result.fold(
      (l) => value = FailureTodosState(l),
      (r) => value = SuccessTodosFailure(r),
    );
  }

  ///Update
  void updateTodo(TodoItem item) {
    final idx = (value as SuccessTodosFailure).todosItens.indexOf(item);
    value = (value as SuccessTodosFailure)..todosItens[idx] = item;

    notifyListeners();

    //update on cache
    _updateTodo(item);
  }

  void createTodo(TodoItem item) {
    value = (value as SuccessTodosFailure)
      ..todosItens.add(TodoItemModel.fromItem(item));
    notifyListeners();

    _createTodo(item);
  }

  void deleteTodo(TodoItem item) {
    value = (value as SuccessTodosFailure)..todosItens.remove(item); //where?
    notifyListeners();

    _deleteTodo(item.id).then((_) => _updateTodosOrders());
  }

  void reorder(int oldIndex, int newIndex) {
    //in widget reorder up to down the newIndex is comming +1
    final newIdx = (oldIndex > newIndex) ? newIndex : newIndex - 1;

    (value as SuccessTodosFailure).todosItens.insert(
          newIdx,
          (value as SuccessTodosFailure).todosItens.removeAt(oldIndex),
        );

    _updateTodosOrders();
  }

  void _updateTodosOrders() {
    final originTodos = (value as SuccessTodosFailure).todosItens;

    for (var i = 0; i < originTodos.length; i++) {
      originTodos[i].order = i;
    }

    notifyListeners();

    //update cache
    _updateTodoList(originTodos);
  }
}
