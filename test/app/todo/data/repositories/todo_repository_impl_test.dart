import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/app/todo/data/datasources/todo_datasource.dart';

import 'package:mocktail/mocktail.dart';
import 'package:todo_list/app/todo/data/models/todo_model.dart';
import 'package:todo_list/app/todo/data/repositories/todo_repository_impl.dart';
import 'package:todo_list/app/todo/domain/entities/todo_item.dart';
import 'package:todo_list/core/app_failure.dart';

class MockLocalDatasource extends Mock implements TodoDatasource {}

void main() {
  final localDatasource = MockLocalDatasource();

  final repository = TodoRepositoryImpl(localDatasource);

  final genericTodo = TodoItem(todo: 'todo', order: 0);
  const genericErrorMessage = 'expeted';

  setUpAll(() {
    registerFallbackValue(genericTodo);
  });

  test('create todo successfully', () async {
    final todoModel = TodoItemModel.fromItem(
      genericTodo.copyWith(done: true),
    );

    when(() => localDatasource.createOrUpdateTodo(genericTodo))
        .thenAnswer((_) async => todoModel);

    final result = await repository.createTodo(genericTodo);
    late TodoItem todoResult;

    result.fold((l) => null, (r) => todoResult = r);

    expect(genericTodo == todoModel, true);
    expect(genericTodo == todoResult, true);
    expect(todoResult.done, true);
  });
  test('create todo withError', () async {
    when(() => localDatasource.createOrUpdateTodo(any()))
        .thenThrow(const UnexpectedFailure(message: genericErrorMessage));

    AppFailure? failure;

    var result = await repository.createTodo(genericTodo);

    result.fold((l) => failure = l, (r) => null);

    expect(failure?.message, genericErrorMessage);

    when(() => localDatasource.createOrUpdateTodo(any()))
        .thenThrow(Exception());

    result = await repository.createTodo(genericTodo);

    result.fold((l) => failure = l, (r) => null);

    expect(failure?.message != null, true);
    expect(failure is AppFailure, true);
  });

  test('delete todo successfully', () async {
    when(() => localDatasource.deleteTodo(any())).thenAnswer((_) async {});

    final result = await repository.deleteTodo(genericTodo.id);

    result.fold((l) => null, (r) => null);

    expect(result.isRight(), true);
  });
  test('delete todo withError', () async {
    when(() => localDatasource.deleteTodo(any()))
        .thenThrow(const UnexpectedFailure(message: genericErrorMessage));

    AppFailure? failure;

    var result = await repository.deleteTodo(genericTodo.id);

    result.fold((l) => failure = l, (r) => null);

    expect(failure?.message, genericErrorMessage);

    when(() => localDatasource.deleteTodo(any())).thenThrow(Exception());

    result = await repository.deleteTodo(genericTodo.id);

    result.fold((l) => failure = l, (r) => null);

    expect(failure?.message != null, true);
    expect(failure is AppFailure, true);
  });

  test('update todo successfully', () async {
    final todoModel = TodoItemModel.fromItem(genericTodo);

    when(() => localDatasource.createOrUpdateTodo(genericTodo))
        .thenAnswer((_) async => todoModel);

    var result = await repository.updateTodo(genericTodo);
    late TodoItem todoResult;

    result.fold((l) => null, (r) => todoResult = r);

    expect(genericTodo == todoModel, true);
    expect(genericTodo == todoResult, true);
    expect(todoResult.done, false);
    expect(todoResult.order, 0);

    final updatedModel = TodoItemModel.fromItem(
      genericTodo.copyWith(done: true, order: 5),
    );

    when(() => localDatasource.createOrUpdateTodo(genericTodo))
        .thenAnswer((_) async => updatedModel);

    result = await repository.updateTodo(genericTodo);
    result.fold((l) => null, (r) => todoResult = r);

    expect(todoResult.done, true);
    expect(todoResult.order, 5);
  });
  test('update todo withError', () async {
    when(() => localDatasource.createOrUpdateTodo(any()))
        .thenThrow(const UnexpectedFailure(message: genericErrorMessage));

    AppFailure? failure;

    var result = await repository.updateTodo(genericTodo);

    result.fold((l) => failure = l, (r) => null);

    expect(failure?.message, genericErrorMessage);

    when(() => localDatasource.createOrUpdateTodo(any()))
        .thenThrow(Exception());

    result = await repository.updateTodo(genericTodo);

    result.fold((l) => failure = l, (r) => null);

    expect(failure?.message != null, true);
    expect(failure is AppFailure, true);
  });

  test('getAll todo successfully', () async {
    final todoModel1 = TodoItemModel.fromItem(genericTodo);
    final todoModel2 = TodoItemModel(id: '2', todo: 'todo2', order: 3);

    final todos = [todoModel1, todoModel2];

    when(() => localDatasource.getAllTodos()).thenAnswer((_) async => todos);

    var result = await repository.getAllTodosList();
    late List<TodoItem> todoResult;

    result.fold((l) => null, (r) => todoResult = r);

    expect(todoResult.length, 2);
    expect(todoResult.last.id, '2');

    final reorderedTodos = [
      TodoItemModel.fromItem(todoModel1.copyWith(order: 10)),
      todoModel2,
    ];

    when(() => localDatasource.getAllTodos())
        .thenAnswer((_) async => reorderedTodos);

    result = await repository.getAllTodosList();
    result.fold((l) => null, (r) => todoResult = r);

    expect(todoResult.length, 2);
    expect(todoResult.first.id, '2');
  });
  test('getAll todo withError', () async {
    when(() => localDatasource.getAllTodos())
        .thenThrow(const UnexpectedFailure(message: genericErrorMessage));

    AppFailure? failure;

    var result = await repository.getAllTodosList();

    result.fold((l) => failure = l, (r) => null);

    expect(failure?.message, genericErrorMessage);

    when(() => localDatasource.getAllTodos()).thenThrow(Exception());

    result = await repository.getAllTodosList();

    result.fold((l) => failure = l, (r) => null);

    expect(failure?.message != null, true);
    expect(failure is AppFailure, true);
  });

  test('updateAll todo successfully', () async {
    final todoModel1 = TodoItemModel.fromItem(genericTodo);
    final todoModel2 = TodoItemModel(id: '2', todo: 'todo2', order: 3);

    final todos = [todoModel1, todoModel2];

    when(() => localDatasource.updateTodosListOrder(any()))
        .thenAnswer((_) async {});

    var result = await repository.updateTodoListOrder(todos);

    result.fold((l) => null, (r) => null);

    expect(result.isRight(), true);
  });
  test('updateAll todo withError', () async {
    when(() => localDatasource.updateTodosListOrder(any()))
        .thenThrow(const UnexpectedFailure(message: genericErrorMessage));

    AppFailure? failure;

    var result = await repository.updateTodoListOrder([]);

    result.fold((l) => failure = l, (r) => null);

    expect(failure?.message, genericErrorMessage);

    when(() => localDatasource.updateTodosListOrder(any()))
        .thenThrow(Exception());

    result = await repository.updateTodoListOrder([]);

    result.fold((l) => failure = l, (r) => null);

    expect(failure?.message != null, true);
    expect(failure is AppFailure, true);
  });
}
