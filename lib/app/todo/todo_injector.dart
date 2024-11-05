import 'package:get_it/get_it.dart';
import 'package:todo_list/app/todo/data/datasources/todo_datasource.dart';
import 'package:todo_list/app/todo/data/repositories/todo_repository_impl.dart';
import 'package:todo_list/app/todo/domain/repositories/todo_repository.dart';
import 'package:todo_list/app/todo/domain/usecases/create_todo.dart';
import 'package:todo_list/app/todo/domain/usecases/delete_todo.dart';
import 'package:todo_list/app/todo/domain/usecases/get_todo_list.dart';
import 'package:todo_list/app/todo/domain/usecases/update_todo.dart';
import 'package:todo_list/app/todo/domain/usecases/update_todo_list.dart';
import 'package:todo_list/core/rest_service/rest_service_impl.dart';

import 'presenter/stores/todos_list_store.dart';

final _getIt = GetIt.instance;

void registerTodoModuleDependencies() {
  _getIt.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(
      TodoDatasourceImpl(
        RestServiceImpl.todoApi(),
      ),
    ),
  );

  _getIt.registerLazySingleton<TodosListStore>(
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
  _getIt.unregister<TodoRepository>();
  _getIt.unregister<TodosListStore>();
}
