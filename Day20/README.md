# Flutter Riverpod State Management

A Flutter app that demonstrates **Riverpod 3**: `ProviderScope`, `ConsumerWidget`, `Consumer`, `ref.watch / read / listen / select`,
and every provider type: `Provider`, `StateProvider`, `StateNotifierProvider`, `NotifierProvider`, `FutureProvider`, `StreamProvider`.
It also uses **hooks** (`HookConsumerWidget`) and is covered by unit tests.

The Provider app from the previous task was converted to Riverpod: todos, shopping cart, authentication state, and the REST API screens.

## What is inside

| # | Screen | Riverpod concepts |
|---|--------|-------------------|
| 1 | setState vs Riverpod | `StateProvider.autoDispose`, `Consumer`, `ref.watch`, `ref.read`, `ref.listen`, `select` |
| 2 | Todo app | `StateNotifierProvider`, `StateProvider`, computed `Provider`s, **hooks** (`useTextEditingController`) |
| 3 | Shopping cart | `NotifierProvider`, a provider that depends on two others (cart + login) |
| 4 | Authentication state | `NotifierProvider` with an immutable `AuthState`, `ref.listen` for a SnackBar |
| 5 | REST API with FutureProvider | `FutureProvider`, `AsyncValue.when`, `.family`, `ref.invalidate` (retry / refresh) |
| 6 | All provider types | One screen showing live values of every provider type |

## Getting started

```bash
flutter pub add flutter_riverpod hooks_riverpod flutter_hooks http
flutter pub get
flutter run
flutter test        # unit tests (no emulator needed)
```

Riverpod 3 needs Dart 3.7 or newer.

## Project structure

```
lib/
├── main.dart                    # ProviderScope (+ retry setting)
├── models/                      # Post, Comment, Todo, Product
├── providers/
│   ├── counter_providers.dart   # StateProvider
│   ├── todo_providers.dart      # StateNotifierProvider + derived Providers
│   ├── cart_providers.dart      # NotifierProvider + cartSummaryProvider
│   ├── auth_providers.dart      # NotifierProvider + isMemberProvider
│   ├── api_providers.dart       # Provider, FutureProvider, family
│   └── clock_provider.dart      # StreamProvider
├── services/api_service.dart    # HTTP calls (JSONPlaceholder)
├── screens/                     # one screen per demo
└── widgets/                     # CartButton, ErrorView
test/                            # unit tests + a widget smoke test
COMPARISON.md                    # setState vs Provider vs Riverpod
```

---

## Riverpod guide

### 1. Improvements over Provider

| Provider package | Riverpod |
|------------------|----------|
| Providers live **inside the widget tree**. Reading a provider that is not above you fails at runtime (`ProviderNotFoundException`). | Providers are **global declarations** (`final x = Provider(...)`). If the code compiles, the provider exists. |
| One provider per **type**. Two `ChangeNotifierProvider<int>` are ambiguous. | Providers are found by **variable**, so you can have as many of the same type as you want. |
| Needs a `BuildContext` to read state. | Needs only a `ref`, so state can be read inside other providers, services, and tests. |
| Combining state needs `ProxyProvider` and manual wiring. | `ref.watch(otherProvider)` inside a provider combines state, and dependencies are tracked automatically. |
| Async data: you write loading / error / data flags by hand. | `FutureProvider` / `StreamProvider` give an `AsyncValue` with loading, error, and data. |
| Testing needs a widget tree. | Testing needs only a `ProviderContainer`, with `overrides` to fake dependencies. |

### 2. Compile-time safety

- A provider is a normal Dart variable. Misspell its name and the code does not compile (Provider would fail only when the screen opens).
- Types are checked: `ref.watch(todosProvider)` is a `List<Todo>`, `ref.watch(counterProvider)` is an `int`.
- No `ProviderNotFoundException`, because a provider is never "missing from the tree".

### 3. Testing benefits

Providers are plain Dart, so tests need no widgets and no `BuildContext` (see `test/`):

```dart
final container = ProviderContainer(
  overrides: [apiServiceProvider.overrideWithValue(FakeApi())], // replace a dependency
);
addTearDown(container.dispose);

final posts = await container.read(postsProvider.future);
expect(posts.length, 2);
```

### 4. Provider types

| Type | Use it for | In this app |
|------|-----------|-------------|
| `Provider<T>` | Read-only values: services, constants, **computed** values | `apiServiceProvider`, `productCatalogProvider`, `cartSummaryProvider`, `filteredTodosProvider` |
| `StateProvider<T>` | Simple state: a counter, a filter, a search text | `counterProvider`, `todoFilterProvider`, `postsQueryProvider` |
| `StateNotifierProvider<N, S>` | Complex state with methods | `todosProvider` (`TodoNotifier`) |
| `NotifierProvider<N, S>` | Same as StateNotifier, **modern API** | `cartProvider`, `authProvider` |
| `FutureProvider<T>` | One-time async data (API calls) | `postsProvider`, `postByIdProvider` |
| `StreamProvider<T>` | Streams | `clockProvider` |
| `.family` | A provider that takes a parameter | `postCommentsProvider(postId)` |
| `.autoDispose` | Destroy the state when nobody listens | `counterProvider` |

### 5. Using Riverpod

```dart
void main() => runApp(const ProviderScope(child: MyApp()));   // stores all provider state
```

| Widget | When |
|--------|------|
| `ConsumerWidget` | A stateless widget that needs `ref` (most screens) |
| `Consumer` | Rebuild only a small part inside a bigger widget |
| `ConsumerStatefulWidget` | Needs `State` (controllers, form keys) and `ref` |
| `HookConsumerWidget` | `ConsumerWidget` + hooks (`useTextEditingController`, `useState`...) |

| Call | Listens? | Use it |
|------|----------|--------|
| `ref.watch(p)` | Yes | Inside `build`: rebuild when the value changes |
| `ref.watch(p.select((s) => s.x))` | Only when `x` changes | Fewer rebuilds |
| `ref.read(p)` / `ref.read(p.notifier)` | **No** | Inside callbacks: `onPressed` |
| `ref.listen(p, (prev, next) {...})` | Runs a callback | Side effects: SnackBar, navigation |
| `ref.invalidate(p)` / `ref.refresh(p)` | - | Throw away the state and recompute (retry, pull-to-refresh) |

Rule of thumb: **`watch` in `build`, `read` in callbacks.**

### 6. State management with StateNotifier / Notifier

```dart
class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super(const []);

  void add(String title) {
    state = [Todo(id: 1, title: title), ...state];   // a NEW list, never state.add(...)
  }
}

final todosProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) => TodoNotifier());
```

Assigning `state` is what notifies the widgets, so there is no `notifyListeners()`. State must be **immutable**:
a new list / map / object every time.

### 7. API calls with FutureProvider

```dart
final postsProvider = FutureProvider<List<Post>>((ref) {
  return ref.watch(apiServiceProvider).getPosts();
});

ref.watch(postsProvider).when(
  loading: () => const CircularProgressIndicator(),
  error: (e, st) => ErrorView(message: '$e', onRetry: () => ref.invalidate(postsProvider)),
  data: (posts) => PostsList(posts),
);
```

There are no `_loading`, `_error`, `setState`, or `initState` calls. `ref.invalidate` is the retry and the pull-to-refresh.

### 8. Hooks

`HookConsumerWidget` (from `hooks_riverpod`) lets a stateless widget use hooks from `flutter_hooks`.
`useTextEditingController()` creates the controller and disposes it automatically, so the Add-todo form needs no
`StatefulWidget`, `initState`, or `dispose`.

---


## Demo account

`demo@example.com` / `123456` (the login is simulated with a 1 second delay).


