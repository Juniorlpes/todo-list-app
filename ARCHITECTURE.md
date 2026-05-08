# Architecture Proposal

A clean, pragmatic Flutter architecture inspired by Clean Architecture principles and aligned with the [Flutter official app architecture guide](https://docs.flutter.dev/app-architecture/guide).

## Core Principles

1. **Separation of concerns** — Each layer has a single, well-defined responsibility.
2. **Dependency inversion** — Inner layers don't know about outer layers. The domain defines contracts (abstractions); the data layer implements them.
3. **No external dependency for state management** — Uses Flutter's native `ValueNotifier` as the reactive primitive.
4. **No external dependency for feature modularization** — Each feature module manages its own dependency injection lifecycle via injector files.
5. **Immutable entities** — Domain entities are immutable, using `copyWith` for state changes, preventing side effects.
6. **Typed error handling** — Uses `Either<AppFailure, T>` to make errors explicit in the type system, without exceptions leaking across layers.

## Folder Structure

```
lib/
├── main.dart
├── app/
│   ├── app_widget.dart                 # MaterialApp configuration
│   ├── app_routes.dart                 # Route definitions (GoRouter)
│   └── <module>/                       # Feature modules
│       ├── <module>_injector.dart       # DI registration/unregistration
│       ├── <module>_main_component.dart # Entry widget (manages DI lifecycle)
│       ├── domain/
│       │   ├── entities/               # Business entities (immutable)
│       │   └── repositories/           # Repository abstractions (contracts)
│       ├── data/
│       │   ├── models/                 # Data transfer objects (toMap/fromMap)
│       │   ├── datasources/            # Data source abstractions + implementations
│       │   └── repositories/           # Repository implementations
│       └── presenter/
│           ├── stores/                 # State management (ValueNotifier)
│           │   └── states/             # State classes per store
│           ├── controllers/            # Presenter logic (optional, for non-reactive flows)
│           ├── pages/                  # Full screen widgets
│           └── widgets/                # Reusable widgets within the module
├── core/
│   ├── app_failure.dart                # Base failure type hierarchy
│   ├── utils/
│   │   ├── either.dart                 # Either<L,R> implementation
│   │   └── typedefs.dart               # Type aliases (EitherResult, FutureEitherResult)
│   └── <service_abstractions>/         # Infrastructure abstractions (REST, Firebase, Cache)
└── shared/
    └── utils/                          # Shared utilities, constants, extensions
```

## Layers

### Domain Layer
Contains the **business rules**. Defines **what** a module does.

- **Entities**: Pure Dart classes representing business concepts. Immutable, with `copyWith`. Equality based on `id`.
- **Repositories (abstractions)**: Contracts (`abstract class`) that define what data operations exist. Return `FutureEitherResult<T>` to enforce explicit error handling.

```dart
abstract class TodoRepository {
  FutureEitherResult<TodoItem> createTodo(TodoItem item);
  FutureEitherResult<void> deleteTodo(String id);
  FutureEitherResult<List<TodoItem>> getAllTodosList();
}
```

### Data Layer
Tells **how** the module executes its tasks.

- **Models**: Extend entities, add serialization (`toMap`, `fromFireDoc`, `fromJson`, etc). Act as DTOs between datasource and domain.
- **Datasources**: Abstract + concrete classes that interact with external services (Firebase, REST, Hive cache, etc). They throw exceptions on failure.
- **Repositories (implementations)**: Implement domain contracts. Wrap datasource calls in try/catch and convert exceptions to `AppFailure` via `Either`.

```dart
class TodoRepositoryImpl implements TodoRepository {
  final TodoDatasource _datasource;

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

### Presenter Layer
Handles **UI rendering** and **user interaction**.

- **Stores (ViewModels)**: Extend `ValueNotifier<State>`. Hold the UI state and expose methods for user actions. Depend directly on repositories (no usecases needed for most apps).
- **States**: Simple classes representing each possible UI state (`Loading`, `Success`, `Failure`).
- **Pages**: Widget compositions that listen to stores via `ValueListenableBuilder`.
- **Widgets**: Reusable UI components scoped to the module.

```dart
class TodosListStore extends ValueNotifier<TodoListState> {
  final TodoRepository _repository;

  TodosListStore(this._repository) : super(LoadingTodosState()) {
    getAllTodoItens();
  }

  Future<void> getAllTodoItens() async {
    value = LoadingTodosState();
    final result = await _repository.getAllTodosList();
    result.fold(
      (l) => value = FailureTodosState(l),
      (r) => value = SuccessTodosState(r),
    );
  }
}
```

## Error Handling Strategy

### Type hierarchy
```dart
abstract class AppFailure implements Exception {
  final String? message;
  const AppFailure({this.message});
}

class UnexpectedFailure extends AppFailure { ... }
class UserNotAuthenticated extends AppFailure { ... }
// Modules can define their own failure types
```

### Flow
1. **Datasources** throw native exceptions or `AppFailure` subtypes.
2. **Repositories** catch all exceptions and wrap them into `Either<AppFailure, T>`. Known failures keep their type; unknown ones become `UnexpectedFailure`.
3. **Stores/Controllers** use `result.fold()` to handle success/failure — no try/catch needed in the presenter.
4. **UI** reacts to state classes — `FailureTodosState` carries the `AppFailure` so the view can display context-appropriate messages.

### Why Either instead of exceptions?
- Makes error paths **explicit in the type system**.
- Forces callers to handle both success and failure.
- Eliminates unhandled exception crashes.
- No dependency on external packages (`dartz`, `fpdart`).

## Dependency Injection

Uses `GetIt` (service locator) with a per-module lifecycle:

- **Injector files** (`<module>_injector.dart`) register/unregister all module dependencies.
- **MainComponent widgets** (`StatefulWidget`) call `register` in `initState` and `unregister` in `dispose`, ensuring dependencies only live while the module is active.
- **Exported dependencies** (like `SessionController`) are registered at app level and live for the entire app lifecycle.

## Module Entry Pattern

Each module has a `MainComponent` that manages its DI lifecycle:

```dart
class TodoMainComponent extends StatefulWidget {
  @override
  State<TodoMainComponent> createState() => _TodoMainComponentState();
}

class _TodoMainComponentState extends State<TodoMainComponent> {
  @override
  void initState() {
    super.initState();
    registerTodoModuleDependencies();
  }

  @override
  void dispose() {
    unregisterTodoModuleDependencies();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TodoPage();
}
```

## Comparison with Flutter Official Architecture

| Aspect | This Proposal | Flutter Official |
|---|---|---|
| Pattern | Clean Architecture (3 layers) | MVVM (2 layers + optional domain) |
| State Management | `ValueNotifier` (Store) | `ChangeNotifier` (ViewModel) |
| Naming: Presenter logic | Store | ViewModel |
| Naming: Data access abstraction | Datasource | Service |
| Error handling | `Either<AppFailure, T>` | Result pattern or exceptions |
| Usecases | Not used (optional for complex logic) | Optional domain layer |
| DI | GetIt + module injectors | Any DI (get_it, provider, etc.) |

**Key takeaway**: The two approaches are structurally equivalent. The naming differs, but the dependency flow, separation of concerns, and testability are the same.

## Infrastructure Abstractions (core/)

Each data source type has an abstract service in `core/` to isolate external packages:

- **Firebase**: `DataCollectionService<T>` — generic Firestore collection wrapper.
- **REST**: `RestService` — abstracts HTTP client (Dio). All datasources depend on this, so swapping the HTTP package only changes one class.
- **Cache**: `CacheController<T>` — wraps Hive for offline storage.

This ensures that **no datasource depends directly on an external package** — only on the core abstraction.
