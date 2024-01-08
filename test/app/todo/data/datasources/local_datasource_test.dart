import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_list/app/todo/data/datasources/local_datasource.dart';
import 'package:todo_list/app/todo/data/models/todo_model.dart';
import 'package:todo_list/app/todo/domain/entities/todo_item.dart';
import 'package:todo_list/core/cache/cache_controller.dart';

class MockCacheTodoItem extends Mock
    implements CacheController<TodoItemModel> {}

void main() {
  final localCache = MockCacheTodoItem();

  final datasource = TodoLocalDatasourceImpl(localCache);

  final genericTodo = TodoItem(todo: 'todo', order: 0);

  setUpAll(() {
    registerFallbackValue(genericTodo);
    registerFallbackValue(TodoItemModel.fromItem(genericTodo));
  });

  test('getAll', () async {
    final todoModel = TodoItemModel.fromItem(genericTodo);

    when(() => localCache.values).thenAnswer((_) async => [todoModel]);

    var result = await datasource.getAllTodos();

    expect(result.length, 1);
    expect(result.first.todo, 'todo');

    when(() => localCache.values).thenAnswer((_) async => null);

    result = await datasource.getAllTodos();

    expect(result.length, 0);
  });

  test('create or update', () async {
    final todoModel = TodoItemModel.fromItem(genericTodo);

    when(() => localCache.writeByKey(any(), any()))
        .thenAnswer((_) async => true);

    var result = await datasource.createOrUpdateTodo(genericTodo);

    expect(result == todoModel, true);
  });

  test('delete', () async {
    when(() => localCache.deleteByKey(any())).thenAnswer((_) async => true);

    await datasource.deleteTodo(genericTodo.id);
  });

  test('update list', () async {
    final todoModel = TodoItemModel.fromItem(genericTodo);

    when(() => localCache.writeManyByKey(any())).thenAnswer((_) async => true);

    await datasource.updateTodosListOrder([todoModel]);
  });
}
