import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_list/app/todo/data/datasources/todo_datasource.dart';
import 'package:todo_list/app/todo/data/models/todo_model.dart';
import 'package:todo_list/app/todo/domain/entities/todo_item.dart';
import 'package:todo_list/core/rest_service/rest_service.dart';
import 'package:todo_list/core/rest_service/rest_status_code.dart';

class MockRestService extends Mock implements RestService {}

void main() {
  final todoApi = MockRestService();

  final datasource = TodoDatasourceImpl(todoApi);

  final genericTodo = TodoItem(todo: 'todo', order: 0);

  setUpAll(() {
    registerFallbackValue(genericTodo);
    registerFallbackValue(TodoItemModel.fromItem(genericTodo));
  });

  test('getAll', () async {
    final todoModel = TodoItemModel.fromItem(genericTodo);

    when(
      () => todoApi.getList<TodoItemModel>(any(), any()),
    ).thenAnswer(
      (_) async => RestResponse(RestStatusCode.ok)..data = [todoModel],
    );

    var result = await datasource.getAllTodos();

    expect(result.length, 1);
    expect(result.first.todo, 'todo');

    when(
      () => todoApi.getList<TodoItemModel>(any(), any()),
    ).thenAnswer(
      (_) async => RestResponse(RestStatusCode.ok)..data = [],
    );

    result = await datasource.getAllTodos();

    expect(result.length, 0);
  });

  test('create or update', () async {
    final todoModel = TodoItemModel.fromItem(genericTodo);

    when(() => todoApi.postModel<TodoItemModel>(any(), any(), any()))
        .thenAnswer((_) async => RestResponse(RestStatusCode.created)
          ..data = TodoItemModel.fromItem(genericTodo));

    var result = await datasource.createTodo(genericTodo);

    expect(result == todoModel, true);
  });

  test('delete', () async {
    when(() => todoApi.deleteModel(any()))
        .thenAnswer((_) async => RestResponse(RestStatusCode.ok));

    await datasource.deleteTodo(genericTodo.id);
  });

  test('update list', () async {
    final todoModel = TodoItemModel.fromItem(genericTodo);

    when(() => todoApi.putList<TodoItemModel>(any(), any(), any()))
        .thenAnswer((_) async => RestResponse(RestStatusCode.ok));

    await datasource.updateTodosListOrder([todoModel]);
  });
}
