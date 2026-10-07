# Flutter Testing Tasks

Unit tests, widget tests and test coverage for four practice features:
calculator, form validation, API calls (with mocks) and state management.

## 1. Testing types

| Type | What it tests | Speed | Where |
|---|---|---|---|
| **Unit test** | Business logic: one function, method or class, without any UI | Fastest | `test/` |
| **Widget test** | One UI component: rendering and user interactions (tap, enter text, scroll) | Fast | `test/` |
| **Integration test** | The full app running on a real device or emulator | Slowest | `integration_test/` |

This project contains unit tests and widget tests. Integration tests are
described here for understanding only.

## 2. Project structure

```
lib/
  main.dart                          Home menu
  calculator/calculator.dart         Calculator business logic
  calculator/calculator_screen.dart  Calculator UI
  form/validators.dart               Form validation logic
  form/login_form.dart               Form UI
  models/post.dart                   Model
  services/post_service.dart         API call
  posts/posts_screen.dart            List of posts UI
  state/counter_notifier.dart        State management (ChangeNotifier)
  state/counter_screen.dart          Counter UI
test/
  unit/
    calculator_test.dart
    validators_test.dart
    post_model_test.dart
    post_service_test.dart
    counter_notifier_test.dart
  widget/
    calculator_screen_test.dart
    login_form_test.dart
    counter_screen_test.dart
    posts_screen_test.dart
    home_screen_test.dart
```

## 3. Test file setup

- **`test/` directory**: all tests live in `test/` at the project root.
- **Naming convention**: every test file must end with `_test.dart`
  (for example `calculator_test.dart`). `flutter test` only picks up files
  with this suffix.
- **`setUp`**: runs before every test in the file. Used to create a fresh
  object for each test.
- **`tearDown`**: runs after every test. Used to clean up (dispose, close).

```dart
late CounterNotifier notifier;

setUp(() {
  notifier = CounterNotifier();
});

tearDown(() {
  notifier.dispose();
});
```

`setUp` and `tearDown` are used in `calculator_test.dart`,
`counter_notifier_test.dart` and `counter_screen_test.dart`.

## 4. Unit tests

| What | File | Covers |
|---|---|---|
| Functions and methods | `test/unit/calculator_test.dart` | add, subtract, multiply, divide, divide by zero |
| Functions and methods | `test/unit/validators_test.dart` | email and password validation rules |
| Models | `test/unit/post_model_test.dart` | `Post.fromJson`, `Post.toJson` |
| Business logic (API with mocks) | `test/unit/post_service_test.dart` | success, request URL, empty list, error response |
| Business logic (state management) | `test/unit/counter_notifier_test.dart` | increment, decrement, reset, listener notifications |

Assertions are written with `expect(actual, matcher)`:

```dart
expect(calculator.add(2, 3), 5);
expect(calculator.divide(1, 3), closeTo(0.333, 0.001));
expect(() => calculator.divide(10, 0), throwsArgumentError);
expect(Validators.validateEmail('user@mail.com'), isNull);
expect(posts, hasLength(2));
```

### Mocking the API

`PostService` receives its `http.Client` through the constructor, so the test
passes a `MockClient` (from `package:http/testing.dart`) instead of a real
client. No real network request is made.

```dart
final mockClient = MockClient((request) async {
  return http.Response('[{"id":1,"title":"First","body":"Body"}]', 200);
});
final service = PostService(mockClient);
```

## 5. Widget tests

| What | File |
|---|---|
| Widget rendering | all files in `test/widget/` (first test of each file) |
| Tap | `calculator_screen_test.dart`, `counter_screen_test.dart`, `login_form_test.dart`, `home_screen_test.dart` |
| Enter text | `calculator_screen_test.dart`, `login_form_test.dart` |
| Scroll | `posts_screen_test.dart` |
| Form validation in the UI | `login_form_test.dart` |
| API call with mock in the UI | `posts_screen_test.dart` |
| State management in the UI | `counter_screen_test.dart` |

Finding widgets:

```dart
find.byType(TextField)               // by widget type
find.text('Submit')                  // by displayed text
find.byKey(const Key('emailField'))  // by key
find.byIcon(Icons.add)               // by icon
```

User interactions:

```dart
await tester.pumpWidget(const MaterialApp(home: LoginFormScreen()));

await tester.enterText(find.byKey(const Key('emailField')), 'user@mail.com');
await tester.tap(find.text('Submit'));
await tester.pump();                 // rebuild after the interaction

await tester.scrollUntilVisible(
  find.text('Post 30'),
  300,
  scrollable: find.byType(Scrollable),
);

expect(find.text('Form is valid'), findsOneWidget);
```

- `pump()` rebuilds the widget once.
- `pumpAndSettle()` keeps rebuilding until all animations and pending frames
  are finished (used after navigation and after loading data).

## 6. Running the tests

### First time

```bash
flutter pub get
```

To also run the app itself (not required for the tests), generate the
platform folders once with `flutter create .`

### `flutter test` command

```bash
flutter test                                   # all tests
flutter test test/unit                         # unit tests only
flutter test test/widget                       # widget tests only
flutter test test/unit/calculator_test.dart    # one file
flutter test --name "divide"                   # tests whose name matches
```

### Run in the IDE

- **VS Code**: open a `*_test.dart` file and click **Run** or **Debug** above
  `main()`, a `group` or a single `test`. All tests are also listed in the
  **Testing** side panel.
- **Android Studio / IntelliJ**: click the green arrow in the gutter next to
  `main()`, a `group` or a single `test`, or right-click the `test/` folder
  and choose **Run 'tests in test'**.

## 7. Test coverage report

Coverage shows which lines of `lib/` were executed by the tests.

1. Generate the coverage data:

   ```bash
   flutter test --coverage
   ```

   This creates `coverage/lcov.info`.

2. Convert it to an HTML report (requires `lcov`):

   ```bash
   # install lcov once
   # macOS:   brew install lcov
   # Ubuntu:  sudo apt-get install lcov
   # Windows: choco install lcov

   genhtml coverage/lcov.info -o coverage/html
   ```

3. Open the report:

   ```bash
   open coverage/html/index.html        # macOS
   xdg-open coverage/html/index.html    # Linux
   start coverage\html\index.html       # Windows
   ```

The report lists every file in `lib/` with its percentage of covered lines.
Green lines were executed by the tests, red lines were not.

### Results

Result of `flutter test --coverage` (49 tests, all passed):

| File | Lines covered | Coverage | Uncovered lines |
|---|---|---|---|
| `lib/calculator/calculator.dart` | 7 / 7 | 100.0% | - |
| `lib/calculator/calculator_screen.dart` | 36 / 36 | 100.0% | - |
| `lib/form/login_form.dart` | 19 / 19 | 100.0% | - |
| `lib/form/validators.dart` | 7 / 7 | 100.0% | - |
| `lib/main.dart` | 20 / 24 | 83.3% | 11, 12, 60, 62 |
| `lib/models/post.dart` | 8 / 8 | 100.0% | - |
| `lib/posts/posts_screen.dart` | 22 / 22 | 100.0% | - |
| `lib/services/post_service.dart` | 8 / 8 | 100.0% | - |
| `lib/state/counter_notifier.dart` | 10 / 10 | 100.0% | - |
| `lib/state/counter_screen.dart` | 20 / 20 | 100.0% | - |
| **Total** | **157 / 161** | **97.5%** | |

Uncovered lines in `lib/main.dart`:

- Lines 11-12: the `main()` function that calls `runApp`. Widget tests pump
  `MyApp` directly, so `main()` itself is not executed.
- Lines 60, 62: the "Posts" menu item creates a real `http.Client`. It is not
  tapped in tests to avoid a real network call; `PostsScreen` is tested
  separately with a mocked client.

The full report is in `coverage_report.html`.

## 8. Testing best practices used here

- One behaviour per test, with a name that describes the expected result.
- Arrange, Act, Assert order inside every test.
- Logic is kept outside widgets (`Calculator`, `Validators`, `PostService`,
  `CounterNotifier`) so it can be unit tested without UI.
- Dependencies are injected (`http.Client`, `CounterNotifier`) so they can be
  replaced with mocks in tests.
- Tests are independent: `setUp` creates fresh objects for each test.
- Related tests are grouped with `group`.
