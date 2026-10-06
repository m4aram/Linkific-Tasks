# Debugging practice document

How to use this document: run each lab, find the bug with the tool in the **Tool** column BEFORE looking at the fix,
write what you saw, then switch the app to the FIXED version and write the result.

## 0. Setup

| Task | Command / where |
|------|-----------------|
| Debug run (hot reload, overflow stripes, assertions) | `flutter run` |
| **Profile run (use it for any performance number)** | `flutter run --profile` (best on a real phone) |
| Open DevTools | Android Studio: Run window > "Open DevTools", or press `d` in the terminal after `flutter run` |
| DevTools tabs | Inspector, Performance (frame chart + timeline events), CPU Profiler, Memory, Network, Logging |

Debug builds are 5 to 10 times slower than release. Never judge speed in debug mode, and an emulator is not a real phone.

## 1. The bugs

| # | Lab | Symptom | Tool | Cause | Fix |
|---|-----|---------|------|-------|-----|
| 1 | Logging | The order total is 27 instead of 90 | **Debugger: breakpoint** on the `total +=` line, watch `i` and `total` | The loop starts at `i = 1`, so the first item is skipped | `for (final item in items)` |
| 2 | Layout A | Yellow/black stripes, "RenderFlex overflowed by 169 pixels on the right" | Console message + **Inspector > Widget properties / Layout Explorer** | A Row gives a Text unlimited width | `Expanded` around the Text |
| 3 | Layout B | "RenderFlex overflowed by 96 pixels on the bottom" | Console + Inspector | A Column taller than its parent (120 px) | `SingleChildScrollView` |
| 4 | Layout C | "RenderFlex overflowed by 90 pixels on the right" (chips) | Console + Inspector | A Row cannot wrap | `Wrap` |
| 5 | State 1 | Press Add: nothing changes | Add a `debugPrint` in the button and in `build` | The list changed but `setState` was not called | `setState(() => list.add(...))` |
| 6 | State 2 | A ValueNotifier list never updates the UI | Breakpoint inside `ValueListenableBuilder.builder` (it never stops there) | Same list object assigned, so no notification | `value = [...value, x]` |
| 7 | State 3 | After removing Ann, Bob shows Ann's counter | Inspector: look at the widget tree | Without keys, State objects follow the position | `key: ValueKey(name)` |
| 8 | Perf A | Jank on every tap | **Performance** tab: red frame > CPU Profiler > flame chart shows `heavyWork` | 6M iterations inside `build()` | Compute once (`late final`) or move out of build |
| 9 | Perf B | 2000 rows built at once | Counter on screen: "Rows built: 2000 of 2000" | `Column` in a scroll view builds every child | `ListView.builder` ("Rows built: 10 of 2000") |
| 10 | Perf C | The spinner freezes during the calculation | Performance tab: one huge frame on the UI thread | Heavy loop on the main isolate | `compute()` |
| 11 | Perf D | Child rebuilt on every tap | **Inspector > Track widget builds** or the BuildCounter text | The child is created again at every parent rebuild | `const` constructor |
| 12 | Memory | Active timers grow, `setState() called after dispose()` every second | **Memory** tab: snapshot, search `_LeakyPageState` | Timer and subscription never cancelled | Cancel in `dispose()` |
| 13 | Network | Requests fail in different ways | **Network** tab + Logging tab | 404 is a response (no exception), no host and timeouts are exceptions | `try/catch` by type + check `statusCode` |
| 14 | Errors | Exceptions in callbacks and async code are lost | Crash log screen + console | Nobody listens | `FlutterError.onError`, `PlatformDispatcher.onError`, `ErrorWidget.builder` |

## 2. Measurements

Device: Android Emulator (Pixel 7a API 36), **debug mode**. Flutter 3.47.1, Dart 3.13.1. Date: October 6, 2026.

| Test | BUGGY | FIXED |
|------|-------|-------|
| B) Rows built (2000 rows) | 2000 of 2000 | 10 of 2000 |
| C) Heavy calculation, 60 million steps | blocks the UI thread, the spinner freezes | `compute()`: 1399 ms, the interface stays responsive |
Profile mode (flutter run --profile), Performance lab, Rebuild pressed 5 times: average 57 FPS, 475 slow frames recorded in the session.
Frame monitor readings (the HUD in the Performance lab):

| Moment | Frames | Jank frames | Average | Worst frame |
|--------|--------|-------------|---------|-------------|
| BUGGY screen (2000 rows built at once) | 1537 | 1272 (83%) | 32.3 ms | 4943 ms |
| After switching to FIXED (counters not reset) | 3000 | 2727 (91%) | 33.6 ms | 4943 ms |

How to read these numbers:

- The **worst frame of 4943 ms** is the one-time cost of building 2000 rows in the buggy version (test B). It stayed in the statistics after the switch to FIXED because the counters were not reset. This is the real finding.
- The average of about 32 to 34 ms means the emulator draws about 30 frames per second in debug mode even when idle, so the **jank percentages are not meaningful** here. Exact frame times need `flutter run --profile` on a real phone.
- The counters (rows built, build count) do not depend on speed, so they are reliable even in debug mode.



## 3. What was observed

- **Console**: three messages `A RenderFlex overflowed by 169 / 96 / 90 pixels` when the buggy Layout lab opened. The Inspector counted the same three errors (`Errors: 3`).
- **Breakpoint exercise**: the buggy order total shows `27.0`, the fixed one shows `90.0`.
- **assert**: the SnackBar `Asserts are ON (debug mode)` confirms the app runs in debug mode, and the AssertionError appears in the console.
- **Rows built**: 2000 of 2000 (buggy) versus 10 of 2000 (fixed).
- **compute()**: the 60-million-step calculation took 1399 ms without freezing the interface.
- **Bugs found in the project itself while testing**:
   1. `Build scheduled during frame`: the crash reporter changed a list that the UI listens to while a layout overflow was being reported. Fixed by publishing the update after the frame.
   2. The memory leak counters stayed at zero: they were changed inside `initState` and `dispose`, which run while Flutter builds the tree. Fixed by publishing the counters in a microtask.
   3. The assert button looked like it did nothing, because an assert only prints to the console. Fixed by adding a SnackBar.

## 4. A debugging workflow that works

1. **Reproduce** the bug with the shortest steps.
2. **Read** the error message and the first line of the stack trace that is in YOUR code.
3. **Choose the tool**: wrong value = breakpoint; wrong layout = Inspector; slow = Performance + CPU Profiler;
   growing memory = Memory; wrong server answer = Network.
4. **Change one thing**, test, repeat.
5. **Write a test** that would have caught it (see `test/`): 14 tests, all passing.
