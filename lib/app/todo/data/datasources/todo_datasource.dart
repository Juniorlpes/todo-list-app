import 'package:todo_list/app/todo/data/models/todo_model.dart';
import 'package:todo_list/app/todo/domain/entities/todo_item.dart';
import 'package:todo_list/core/firebase/firestore_collection_service.dart';

abstract class TodoDatasource {
  Future<List<TodoItemModel>> getAllTodos();
  Future<TodoItemModel> createOrUpdateTodo(TodoItem item);
  Future<void> deleteTodo(String id);
  Future<void> updateTodosListOrder(List<TodoItem> itens);
}

class TodoDatasourceImpl implements TodoDatasource {
  final DataCollectionService<TodoItemModel> _todoCollection;

  TodoDatasourceImpl(this._todoCollection);

  @override
  Future<List<TodoItemModel>> getAllTodos() async {
    return (await _todoCollection.getAll())
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  @override
  Future<TodoItemModel> createOrUpdateTodo(TodoItem item) async {
    final todo = TodoItemModel.fromItem(item);
    await _todoCollection.create(todo);
    return todo;
  }

  @override
  Future<void> deleteTodo(String id) async {
    await _todoCollection.delete(id);
  }

  @override
  Future<void> updateTodosListOrder(List<TodoItem> itens) async {
    for (var item in itens) {
      await _todoCollection.update(TodoItemModel.fromItem(item));
    }
  }
}
