# Flutter Provider State Management

A Flutter app that demonstrates state management with the **provider** package:
`ChangeNotifier`, `Consumer`, `context.watch / read / select`, `MultiProvider`, `ProxyProvider`,
`FutureProvider`, and `StreamProvider`.

## What is inside

| # | Screen | Provider concepts used |
|---|--------|------------------------|
| 1 | Provider vs setState | `ChangeNotifier`, `Consumer`, `Provider.of`, `watch`, `read`, `select`, **scoped** provider |
| 2 | Todo app | `TodoProvider` (add, toggle, delete, filter), `Consumer`, `context.select` |
| 3 | Shopping cart | `CartProvider`, `ProxyProvider` (`CartSummary`), `ChangeNotifierProxyProvider`, `Consumer2` |
| 4 | Authentication state | `AuthProvider` (logged out / loading / logged in, error, logout) |
| 5 | REST API with Provider | The previous REST API app converted: `PostsProvider` (loading, error, retry, search, refresh) |
| 6 | Provider patterns | `FutureProvider`, `StreamProvider`, `MultiProvider`, scope |

## Getting started

```bash
flutter pub add provider http
flutter pub get
flutter run
```

## Project structure

```
lib/
├── main.dart                 # MultiProvider with all app-wide providers
├── models/                   # Post, Todo, Product (+ ProductCatalog)
├── providers/                # ChangeNotifiers: Counter, Todo, Auth, Cart, Posts
├── services/api_service.dart # HTTP calls (JSONPlaceholder)
├── screens/                  # one screen per demo
├── widgets/                  # CartButton (badge), ErrorView
└── utils/format.dart
```

---

## Provider patterns guide

### 1. Why Provider?

`setState` keeps state inside one widget. When two screens need the same data (the cart badge in the AppBar
and the cart screen), you would have to pass it down through constructors. Provider puts the state **above**
the widgets that need it, and any widget below can read it.

### 2. Provider vs setState

| | `setState` | Provider |
|---|-----------|----------|
| Where the state lives | Inside one `StatefulWidget` | In a separate class (`ChangeNotifier`) |
| Sharing between screens | Hard (pass through constructors) | Easy (read from the tree) |
| What rebuilds | The whole widget | Only the `Consumer` / `select` parts |
| Testing the logic | Needs a widget | Plain Dart class |
| Best for | Small local UI state (a toggle, a text field) | Shared or business state (cart, auth, API data) |

Screen 1 shows this live: the setState card rebuilds completely, while the Provider card's outer widget is
built once and only the `Consumer` rebuilds.

### 3. Provider types used in this project

| Type | Used for | Where |
|------|----------|-------|
| `Provider<T>` | A value that never changes (dependency injection) | `ApiService`, `ProductCatalog` |
| `ChangeNotifierProvider<T>` | State that changes and notifies | `AuthProvider`, `TodoProvider`, `PostsProvider`, `CounterProvider` |
| `ChangeNotifierProxyProvider<A, B>` | A notifier that depends on another provider | `CartProvider` depends on `AuthProvider` |
| `ProxyProvider<A, B>` | A read-only value derived from another provider | `CartSummary` from `CartProvider` |
| `FutureProvider<T>` | Exposes the result of a one-time `Future` | "Daily post" in the patterns screen |
| `StreamProvider<T>` | Exposes the values of a `Stream` | Live clock in the patterns screen |
| `MultiProvider` | Registers many providers in one flat list | `main.dart`, patterns screen |

### 4. ChangeNotifier

```dart
class CounterProvider extends ChangeNotifier {
  int _value = 0;
  int get value => _value;          // state is private, exposed with getters

  void increment() {
    _value++;
    notifyListeners();              // tells all listening widgets to rebuild
  }
}
```

Rules:
- Keep state private and expose it with getters.
- Change state only through methods, and call `notifyListeners()` after every change.
- Never call `notifyListeners()` while a widget is building.

### 5. Setup: ChangeNotifierProvider, MultiProvider and scope

```dart
MultiProvider(
  providers: [
    Provider<ApiService>(create: (_) => ApiService()),
    ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
    ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
      create: (_) => CartProvider(),
      update: (_, auth, cart) => cart!..updateMembership(auth.isLoggedIn),
    ),
    ProxyProvider<CartProvider, CartSummary>(
      update: (_, cart, __) => CartSummary.fromCart(cart),
    ),
  ],
  child: MaterialApp(...),
)
```

**Scope** decides who can use a provider and how long it lives:
- Providers in `main.dart` are global: every screen can use them and their state survives navigation
  (auth, cart, todos, posts).
- A provider created inside a screen (`CounterScreen`, `PatternsScreen`) exists only while that screen is open.
  When you leave, it is disposed (the counter resets, the stream is cancelled).

### 6. Consuming state

| Style | Listens? | Use it |
|-------|----------|--------|
| `Consumer<T>(builder: ...)` | Yes | Rebuild only a part of the tree |
| `context.watch<T>()` | Yes | Inside `build`, when the whole widget depends on the value |
| `Provider.of<T>(context)` | Yes | Same as `watch` (older style) |
| `context.select<T, R>((t) => ...)` | Only when the selected value changes | Best for performance (badge count, filter) |
| `context.read<T>()` | **No** | Inside callbacks: `onPressed`, `initState` |
| `Provider.of<T>(context, listen: false)` | **No** | Same as `read` (older style) |
| `Consumer2<A, B>` | Yes | Listen to two providers at once (cart screen) |

Rule of thumb: **`watch` in `build`, `read` in callbacks.**

### 7. Patterns

**Multiple providers**: five `ChangeNotifier`s (Counter, Todo, Auth, Cart, Posts) work independently, and
the cart and auth providers cooperate through `ChangeNotifierProxyProvider`.

**ProxyProvider**: when state depends on other state.
Logging in changes `AuthProvider` -> `CartProvider.isMember` updates -> `CartSummary` recalculates the discount
-> the cart screen rebuilds. No screen calls another screen.

**FutureProvider**: good for one-time loads. It has no refresh and no error state by itself, so the project wraps the
result in a small `DailyPost` class. For anything that needs retry, refresh or search, use a `ChangeNotifier`
(`PostsProvider`) instead.

**StreamProvider**: for values that keep coming (clock, Firebase/Supabase streams, WebSocket).
It subscribes automatically and cancels when the provider is disposed.

---

## Converting the REST API app to Provider

Before (setState inside the screen):

```dart
bool _loading = true;
String? _error;
List<Post> _posts = [];
Future<void> _load() async { setState(...); ... }
```

After (state in `PostsProvider`, screen is a `StatelessWidget`):

```dart
Consumer<PostsProvider>(
  builder: (context, provider, _) {
    switch (provider.status) {
      case PostsStatus.loading: return const Center(child: CircularProgressIndicator());
      case PostsStatus.error:   return ErrorView(message: provider.error!, onRetry: provider.load);
      case PostsStatus.ready:   return PostsList(provider.visiblePosts);
    }
  },
)
```

The HTTP code (`ApiService`) did not change. Only the place where the state lives changed.

## Demo account

`demo@example.com` / `123456` (login is simulated with a 1 second delay; any other credentials show an error).


