import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_list/app/todo/data/models/todo_model.dart';
import 'package:todo_list/app/todo/domain/entities/todo_item.dart';
import 'package:todo_list/app/todo/domain/repositories/todo_repository.dart';
import 'package:todo_list/app/todo/domain/usecases/create_todo.dart';
import 'package:todo_list/app/todo/domain/usecases/delete_todo.dart';
import 'package:todo_list/app/todo/domain/usecases/get_todo_list.dart';
import 'package:todo_list/app/todo/domain/usecases/update_todo.dart';
import 'package:todo_list/app/todo/domain/usecases/update_todo_list.dart';
import 'package:todo_list/app/todo/presenter/stores/todos_list_store.dart';
import 'package:todo_list/core/utils/either.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  final mockRepository = MockTodoRepository();

  when(() => mockRepository.getAllTodosList())
      .thenAnswer((_) async => right([]));

  final todoStore = TodosListStore(
    CreateTodo(mockRepository),
    UpdateTodo(mockRepository),
    DeleteTodo(mockRepository),
    GetTodosList(mockRepository),
    UpdateTodoList(mockRepository),
  );

  final genericTodo = TodoItem(todo: 'todo', order: 0);

  setUpAll(() {
    registerFallbackValue(genericTodo);
  });

  test('GetAll', () async {
    final todo2 = TodoItem(todo: 'todo2', order: 1);

    when(() => mockRepository.getAllTodosList())
        .thenAnswer((_) async => right([genericTodo, todo2]));

    await todoStore.getAllTodoItens();

    expect(todoStore.value is SuccessTodosFailure, true);
    expect((todoStore.value as SuccessTodosFailure).todosItens.length, 2);
  });

  test('create', () async {
    todoStore.value = SuccessTodosFailure(
        [TodoItemModel.fromItem(TodoItem(todo: 'todo', order: 1))]);

    when(() => mockRepository.createTodo(genericTodo))
        .thenAnswer((_) async => right(TodoItemModel.fromItem(genericTodo)));

    todoStore.createTodo(genericTodo);

    expect((todoStore.value as SuccessTodosFailure).todosItens.length, 2);
  });

  test('delete', () async {
    todoStore.value = SuccessTodosFailure([genericTodo]);

    when(() => mockRepository.deleteTodo(any()))
        .thenAnswer((_) async => right(null));
    when(() => mockRepository.updateTodoListOrder(any()))
        .thenAnswer((_) async => right(null));

    todoStore.deleteTodo(genericTodo);

    expect((todoStore.value as SuccessTodosFailure).todosItens.length, 0);
  });

  test('update', () async {
    final todo2 = TodoItem(todo: 'todo', order: 3);

    todoStore.value = SuccessTodosFailure([genericTodo, todo2]);

    when(() => mockRepository.updateTodo(any()))
        .thenAnswer((_) async => right(genericTodo));

    expect(genericTodo.done, false);
    expect(
        (todoStore.value as SuccessTodosFailure).todosItens.first.done, false);

    genericTodo.done = true;

    todoStore.updateTodo(genericTodo);

    expect(
        (todoStore.value as SuccessTodosFailure).todosItens.first.done, true);
  });

  test('reorder', () async {
    todoStore.value = SuccessTodosFailure(
        [genericTodo, TodoItem(id: '2', todo: 'todo2', order: 1)]);

    when(() => mockRepository.updateTodoListOrder(any()))
        .thenAnswer((_) async => right(null));

    todoStore.reorder(1, 0);

    expect((todoStore.value as SuccessTodosFailure).todosItens.length, 2);
    expect((todoStore.value as SuccessTodosFailure).todosItens.first.id, '2');
  });
}
