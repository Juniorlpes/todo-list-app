import 'package:todo_list/app/todo/domain/entities/todo_item.dart';
import 'package:todo_list/core/utils/typedefs.dart';

abstract class TodoRepository {
  FutureEitherResult<TodoItem> createTodo(TodoItem item);
  FutureEitherResult<void> deleteTodo(String id);
  FutureEitherResult<TodoItem> updateTodo(TodoItem item);
  FutureEitherResult<List<TodoItem>> getAllTodosList();
  FutureEitherResult<void> updateTodoListOrder(List<TodoItem> itens);
}
