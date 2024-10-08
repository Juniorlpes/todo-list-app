import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_list/app/todo/data/datasources/todo_datasource.dart';
import 'package:todo_list/app/todo/data/models/todo_model.dart';
import 'package:todo_list/app/todo/domain/entities/todo_item.dart';
import 'package:todo_list/core/firebase/firestore_collections/todo_sub_collection.dart';

class MockTodoFireCollection extends Mock implements TodoSubCollection {}

void main() {
  final todoCollection = MockTodoFireCollection();

  final datasource = TodoDatasourceImpl(todoCollection);

  final genericTodo = TodoItem(todo: 'todo', order: 0);

  setUpAll(() {
    registerFallbackValue(genericTodo);
    registerFallbackValue(TodoItemModel.fromItem(genericTodo));
  });

  test('getAll', () async {
    final todoModel = TodoItemModel.fromItem(genericTodo);

    when(() => todoCollection.getAll()).thenAnswer((_) async => [todoModel]);

    var result = await datasource.getAllTodos();

    expect(result.length, 1);
    expect(result.first.todo, 'todo');

    when(() => todoCollection.getAll()).thenAnswer((_) async => []);

    result = await datasource.getAllTodos();

    expect(result.length, 0);
  });

  test('create or update', () async {
    final todoModel = TodoItemModel.fromItem(genericTodo);

    when(() => todoCollection.create(any()))
        .thenAnswer((_) async => todoModel.id);

    var result = await datasource.createOrUpdateTodo(genericTodo);

    expect(result == todoModel, true);
  });

  test('delete', () async {
    when(() => todoCollection.delete(any())).thenAnswer((_) async => true);

    await datasource.deleteTodo(genericTodo.id);
  });

  test('update list', () async {
    final todoModel = TodoItemModel.fromItem(genericTodo);

    when(() => todoCollection.update(any())).thenAnswer((_) async => true);

    await datasource.updateTodosListOrder([todoModel]);
  });
}
