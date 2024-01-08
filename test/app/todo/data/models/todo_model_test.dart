import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/app/todo/data/models/todo_model.dart';
import 'package:todo_list/app/todo/domain/entities/todo_item.dart';

void main() {
  test('Instance', () {
    final todo1 = TodoItemModel(id: '1', todo: 'todo 1', order: 0);
    final todo2 = TodoItemModel(id: '2', todo: 'todo 2', order: 1);

    expect(todo1 == todo1, true);
    expect(todo1 == todo2, false);

    expect(todo1.compareTo(todo2), -1);
  });

  test('fromItem', () {
    final todo1 = TodoItem(todo: '1', order: 0);

    final todoModel1 = TodoItemModel.fromItem(todo1);

    expect(todo1 == todoModel1, true);
  });
}
