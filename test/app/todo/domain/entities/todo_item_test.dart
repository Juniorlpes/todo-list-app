import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/app/todo/domain/entities/todo_item.dart';

void main() {
  test('Instance', () {
    final todo1 = TodoItem(
      id: '1',
      todo: 'Todo 1',
      order: 0,
    );
    final todo1_ = TodoItem(
      id: '1',
      todo: 'Todo 1 *',
      order: 1,
    );
    final todo2 = TodoItem(
      todo: 'Todo 2',
      order: 5,
    );

    expect(todo1 == todo1, true);
    expect(todo1 == todo1_, true); //id
    expect(todo1 == todo2, false);

    expect(todo1.compareTo(todo1_), -1);

    todo1.toString();
    todo1.hashCode;
  });
}
