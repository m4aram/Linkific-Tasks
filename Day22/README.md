# Flutter Debug Lab 22 day

An app made of small labs. Each lab has an intentional bug and its fix, so you can practice finding bugs with
the Flutter debugging tools.

| Lab | Bug | Main tool |
|-----|-----|-----------|
| Logging | Wrong order total | Breakpoints, `print` / `debugPrint` / `developer.log` |
| Layout overflow | `RenderFlex overflowed` | Inspector, Layout Explorer |
| State not updating | Missing `setState`, in-place change, missing keys | Breakpoints, Inspector |
| Performance | Work in `build()`, `Column` vs `ListView.builder`, main thread, rebuilds | Performance, CPU Profiler, frame HUD |
| Memory leak | Timer and subscription never cancelled | Memory |
| Network | 200, 404, no host, timeout, invalid JSON | Network, Logging |
| Error handling | Uncaught errors, broken `build()` | `FlutterError.onError`, `PlatformDispatcher.onError`, `ErrorWidget.builder` |

## Getting started

```bash
flutter pub add http
flutter run              # debugging
flutter run --profile    # performance measurements
flutter test             # 14 tests
```

Read [DEBUGGING_PRACTICE.md](DEBUGGING_PRACTICE.md) (the practice document) and [docs/CRASHLYTICS.md](docs/CRASHLYTICS.md).

## Debugging tips

### Basics
- Prefer `debugPrint` to `print`: it throttles long output so the OS does not drop lines, and it is stripped in release logic you guard with `kDebugMode`.
- Use `developer.log(message, name: 'MyFeature', level: 900)`: DevTools > Logging can filter by name and level.
- A **breakpoint** (click next to the line number) is better than `print` when the value is wrong: you see every variable and can step line by line (Step Over F8, Step Into F7).
- `assert` runs only in debug mode. Never put needed logic inside an `assert`.
- `debugDumpApp()` prints the whole widget tree. `debugPrintStack()` prints who called a function.

### DevTools
- **Inspector**: select a widget, see its properties, the Layout Explorer, and "Track widget builds" (rebuild counts).
- **Performance** (it contains the old "Timeline"): the frame chart and Frame Analysis. A red frame is slower than the budget (16.7 ms at 60 Hz, 8.3 ms at 120 Hz). Look at the UI thread (your Dart code) and the raster thread (drawing).
- **CPU Profiler**: record, reproduce the slow action, stop, then read the flame chart or the bottom-up table. The widest bar is the slow function.
- **Memory**: take snapshots, press GC, compare them, search a class name. Instances that never go away are leaks.
- **Network**: every HTTP request with status, time, size and headers.
- **Logging**: `developer.log`, `debugPrint`, framework events and errors.

### Common problems
| Problem | Check |
|---------|-------|
| Overflow stripes | `Expanded` / `Flexible`, `Wrap`, `SingleChildScrollView` |
| UI does not update | Did you call `setState`? Did you assign a NEW list/object? Do list items need keys? |
| Jank | Profile mode first. Heavy work in `build`? Use `const`, `ListView.builder`, `compute()`, and split big widgets |
| Memory grows | Did you cancel timers, subscriptions and dispose controllers (`AnimationController`, `TextEditingController`)? |
| `setState() called after dispose()` | A callback still runs after the widget is gone: cancel it in `dispose()` or check `mounted` |
| Network error | `statusCode` (http does not throw on 404), timeouts, no connection, invalid JSON |

### Optimization checklist
- Use `const` constructors wherever possible.
- Keep `build()` cheap: no loops over big data, no parsing, no sorting.
- Rebuild less: put `setState` in the smallest widget that needs it, or use `ValueListenableBuilder` / `Consumer`.
- Long lists: `ListView.builder`. Heavy work: `compute()`.
- Measure before and after, in profile mode.

## Error handling in this project

`lib/error/error_handling.dart` connects the three hooks, and `lib/error/crash_reporter.dart` is the interface
that Crashlytics plugs into (setup in docs/CRASHLYTICS.md).

