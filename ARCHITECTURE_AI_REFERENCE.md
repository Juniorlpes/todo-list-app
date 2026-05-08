# Architecture Migration Reference (AI/Copilot)

This file is a structured reference for AI assistants to understand and apply this Flutter architecture when migrating or refactoring an existing app.

## MIGRATION RULES

When migrating an existing Flutter app to this architecture, follow these rules strictly:

### Rule 1: Identify Features/Modules
- Each screen or major feature becomes a **module** under `lib/app/<module>/`.
- A module is a self-contained unit with its own `domain/`, `data/`, and `presenter/` layers.
- Shared entities that are used across modules go in `lib/shared/`.

### Rule 2: Create the Module Skeleton
For each module, create this structure:
```
lib/app/<module>/
├── <module>_injector.dart
├── <module>_main_component.dart
├── domain/
│   ├── entities/
│   └── repositories/
├── data/
│   ├── models/
│   ├── datasources/
│   └── repositories/
└── presenter/
    ├── stores/
    │   └── states/
    ├── controllers/    (optional)
    ├── pages/
    └── widgets/
```

### Rule 3: Entity Rules
- All domain entities are **immutable** (all fields `final`).
- Must have a `copyWith` method.
- Equality should be based on `id` field.
- Entities do NOT contain serialization logic — that goes in models.

```dart
class TodoItem implements Comparable<TodoItem> {
  final String id;
  final int order;
  final String todo;
  final bool done;

  TodoItem({
    required this.todo,
    required this.order,
    this.done = false,
    String? id,
  }) : id = id ?? getNewXid();

  TodoItem copyWith({String? todo, int? order, bool? done}) {
    return TodoItem(
      id: id,
      todo: todo ?? this.todo,
      order: order ?? this.order,
      done: done ?? this.done,
    );
  }

  @override
  bool operator ==(covariant TodoItem other) => other.id == id;

  @override
  int get hashCode => id.hashCode;
}
```

### Rule 4: Model Rules
- Models extend entities.
- Models add serialization: `toMap()`, `fromJson()`, `fromFireDoc()`, etc.
- Models have a `factory fromItem(Entity item)` constructor to convert from entity.

```dart
class TodoItemModel extends TodoItem {
  TodoItemModel({required super.id, required super.todo, required super.order, super.done});

  factory TodoItemModel.fromItem(TodoItem item) => TodoItemModel(
    id: item.id, todo: item.todo, order: item.order, done: item.done,
  );

  Map<String, dynamic> toMap() => {'id': id, 'todo': todo, 'order': order, 'done': done};

  factory TodoItemModel.fromFireDoc(String docId, Map<String, dynamic> map) => TodoItemModel(
    id: docId, todo: map['todo'], order: map['order'], done: map['done'],
  );
}
```

### Rule 5: Repository Contract Rules
- Defined as `abstract class` in `domain/repositories/`.
- All methods return `FutureEitherResult<T>` (which is `Future<Either<AppFailure, T>>`).
- Never reference data layer types (models, datasources).

```dart
abstract class TodoRepository {
  FutureEitherResult<TodoItem> createTodo(TodoItem item);
  FutureEitherResult<void> deleteTodo(String id);
  FutureEitherResult<TodoItem> updateTodo(TodoItem item);
  FutureEitherResult<List<TodoItem>> getAllTodosList();
  FutureEitherResult<void> updateTodoListOrder(List<TodoItem> itens);
}
```

### Rule 6: Repository Implementation Rules
- Located in `data/repositories/`.
- Implements the domain contract.
- Depends on datasources (injected via constructor).
- Wraps ALL datasource calls in try/catch.
- Converts exceptions to `Either`: known `AppFailure` subtypes are preserved, unknown exceptions become `UnexpectedFailure`.

```dart
class TodoRepositoryImpl implements TodoRepository {
  final TodoDatasource _datasource;
  TodoRepositoryImpl(this._datasource);

  @override
  FutureEitherResult<TodoItem> createTodo(TodoItem item) async {
    try {
      return right(await _datasource.createOrUpdateTodo(item));
    } catch (e) {
      return left(e is AppFailure ? e : UnexpectedFailure(message: e.toString()));
    }
  }
}
```

### Rule 7: Datasource Rules
- Defined as `abstract class` + concrete implementation in `data/datasources/`.
- Depends on infrastructure abstractions from `core/` (NOT directly on packages).
- Throws exceptions on failure (the repository catches them).
- Works with Models, not entities.

### Rule 8: Store (ViewModel) Rules
- Extends `ValueNotifier<State>`.
- Depends directly on **Repository** (not usecases).
- Uses `result.fold()` to handle Either responses.
- Exposes methods for user actions.
- ALWAYS does safe state access: check `value is SuccessState` before operating.
- Uses `copyWith` to modify immutable entities.

```dart
class TodosListStore extends ValueNotifier<TodoListState> {
  final TodoRepository _repository;
  TodosListStore(this._repository) : super(LoadingTodosState()) { getAllTodoItens(); }

  List<TodoItem>? get _currentTodos =>
      value is SuccessTodosState ? (value as SuccessTodosState).todosItens : null;

  void updateTodo(TodoItem item) {
    final todos = _currentTodos;
    if (todos == null) return;
    final idx = todos.indexOf(item);
    if (idx == -1) return;
    todos[idx] = item;
    notifyListeners();
    _repository.updateTodo(item);
  }
}
```

### Rule 9: State Rules
- One file per store, containing all state classes.
- States are simple classes, not enums.
- Pattern: `Loading`, `Success(data)`, `Failure(AppFailure)`.

```dart
abstract class TodoListState {}
class LoadingTodosState extends TodoListState {}
class FailureTodosState extends TodoListState {
  final AppFailure failure;
  FailureTodosState(this.failure);
}
class SuccessTodosState extends TodoListState {
  final List<TodoItem> todosItens;
  SuccessTodosState(this.todosItens);
}
```

### Rule 10: Error Handling Rules
- `AppFailure` is the base abstract class in `core/app_failure.dart`.
- `UnexpectedFailure` is the catch-all for unknown errors.
- Modules can define specific failures extending `AppFailure`.
- Datasources throw exceptions. Repositories catch and wrap in Either. Stores fold. UI reacts to state.
- NEVER let exceptions propagate to the presenter layer.

```dart
abstract class AppFailure implements Exception {
  final String? message;
  const AppFailure({this.message});
  @override
  String toString() => message ?? runtimeType.toString();
}

class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure({super.message});
}
```

### Rule 11: Dependency Injection Rules
- Use `GetIt` as service locator.
- Each module has an `<module>_injector.dart` with `register` and `unregister` functions.
- Dependencies that other modules need (exported) are registered at app level.
- Module-internal dependencies are registered/unregistered with the module's lifecycle.
- The `MainComponent` (StatefulWidget) manages register/unregister in initState/dispose.

### Rule 12: Infrastructure Abstraction Rules (core/)
- External packages (Dio, Hive, Firebase) are NEVER imported directly in datasources.
- Create an abstraction in `core/` that wraps the package.
- Datasources depend on the abstraction.
- If the package changes, only the core implementation changes.

Available infrastructure abstractions:

#### REST (`core/rest_service/`)
- `RestService` — abstract class defining HTTP operations (get, post, put, delete)
- `RestServiceImpl` — implementation using Dio
- `RestResponse<T>` — wraps response data + status code + optional error message
- `RestStatusCode` — enum mapping all HTTP status codes
- `NetworkFailure extends AppFailure` — typed failure for REST errors with status code
- `dio_interceptors/` — AuthInterceptor (token injection), PrintLogInterceptor (logging)

Usage in datasource:
```dart
class TodoRestDatasourceImpl implements TodoDatasource {
  final RestService _rest;
  TodoRestDatasourceImpl(this._rest);

  @override
  Future<List<TodoItemModel>> getAllTodos() async {
    final response = await _rest.getList('/todos', (json) => TodoItemModel.fromJson(json));
    if (!response.success) throw NetworkFailure(statusCode: response.statusCode, message: response.errorMessage);
    return response.data;
  }
}
```

#### Firebase (`core/firebase/`)
- `DataCollectionService<T>` — abstract class with typed Firestore collection CRUD
- Implementations: `UsersCollection`, `TodoSubCollection`
- Uses `withConverter` for typed reads/writes

#### Cache (`core/cache/`)
- `CacheController<T>` — generic Hive box wrapper with encryption support
- `CacheBox` — enum for box naming
- `CacheAdaptersId` — central registry for Hive TypeAdapter IDs (avoids conflicts)
- Requires TypeAdapter generation for custom objects (via `hive_generator` or manual)

Usage in datasource:
```dart
class TodoLocalDatasourceImpl implements TodoLocalDatasource {
  final CacheController<TodoItemModel> _cache;
  TodoLocalDatasourceImpl(this._cache);

  @override
  Future<List<TodoItemModel>> getAllTodos() async {
    return (await _cache.values)?.toList() ?? [];
  }
}
```

### Rule 13: View (Page/Widget) Rules
- Views are StatelessWidget when possible.
- Use `ValueListenableBuilder<State>` to listen to stores.
- Use `GetIt.I.get<Store>()` to get store references.
- NEVER put business logic in views — delegate to store methods.
- Use `item.copyWith(...)` instead of mutating entity fields.

### Rule 14: Type Definitions
These typedefs MUST exist in `core/utils/typedefs.dart`:
```dart
typedef EitherResult<T> = Either<AppFailure, T>;
typedef FutureEitherResult<T> = Future<EitherResult<T>>;
```

The `Either` implementation lives in `core/utils/either.dart` — a minimal, dependency-free implementation.

## MIGRATION CHECKLIST

When migrating an existing app, follow this order:

1. [ ] Set up `core/` with `app_failure.dart`, `either.dart`, `typedefs.dart`
2. [ ] Set up `core/` infrastructure abstractions (REST service, cache, etc.)
3. [ ] Set up `shared/` with common utilities
4. [ ] For each feature/screen:
   a. [ ] Create module folder structure
   b. [ ] Extract/create domain entities (make immutable, add copyWith)
   c. [ ] Define repository contract in domain
   d. [ ] Create models extending entities (add serialization)
   e. [ ] Create datasource (abstract + impl)
   f. [ ] Create repository implementation
   g. [ ] Create state classes
   h. [ ] Create store (ValueNotifier)
   i. [ ] Create/refactor pages to use ValueListenableBuilder
   j. [ ] Create injector file
   k. [ ] Create MainComponent widget
5. [ ] Set up routes pointing to MainComponents
6. [ ] Register app-level dependencies in AppWidget

## DEPENDENCY FLOW (NEVER VIOLATE)

```
View → Store → Repository (contract) ← Repository (impl) → Datasource → Core Service
  │                                                              │
  └── ValueListenableBuilder                                     └── Infrastructure (Firebase/REST/Cache)
```

- Views know: Store
- Store knows: Repository contract
- Repository impl knows: Datasource
- Datasource knows: Core service abstractions
- **NO backwards dependencies**
- **Presenter NEVER imports from data/**
- **Domain NEVER imports from data/ or presenter/**
