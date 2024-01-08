import 'package:get_it/get_it.dart';
import 'package:todo_list/app/todo/data/datasources/local_datasource.dart';
import 'package:todo_list/app/todo/data/models/todo_model.dart';
import 'package:todo_list/app/todo/data/repositories/todo_repository_impl.dart';
import 'package:todo_list/app/todo/domain/repositories/todo_repository.dart';
import 'package:todo_list/app/todo/domain/usecases/create_todo.dart';
import 'package:todo_list/app/todo/domain/usecases/delete_todo.dart';
import 'package:todo_list/app/todo/domain/usecases/get_todo_list.dart';
import 'package:todo_list/app/todo/domain/usecases/update_todo.dart';
import 'package:todo_list/app/todo/domain/usecases/update_todo_list.dart';
import 'package:todo_list/core/cache/cache_box_enum.dart';
import 'package:todo_list/core/cache/cache_controller.dart';

import 'presenter/stores/todos_list_store.dart';

final getIt = GetIt.instance;

void registerTodoModuleDependencies() {
  getIt.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      TodoLocalDatasourceImpl(
        CacheController<TodoItemModel>(cacheBoxEnum: CacheBox.todoItem),
      ),
    ),
  );

  getIt.registerLazySingleton<TodosListStore>(
    () => TodosListStore(
      CreateTodo(GetIt.I.get<TodoRepository>()),
      UpdateTodo(GetIt.I.get<TodoRepository>()),
      DeleteTodo(GetIt.I.get<TodoRepository>()),
      GetTodosList(GetIt.I.get<TodoRepository>()),
      UpdateTodoList(GetIt.I.get<TodoRepository>()),
    ),
  );
}

void unregisterTodoModuleDependencies() {
  getIt.unregister<TodoRepository>();
}
