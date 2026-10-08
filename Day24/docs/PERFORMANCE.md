# Performance and App Size Improvements

This document explains each optimization: the problem it solves, how it is applied, and how to verify it.

Measured figures in this document: image compression (section 2.2) and release APK sizes (section 2.4). Build environment: Flutter 3.47.1, Dart 3.13.1.

## 1. Performance

### 1.1 const constructors

- **Problem:** a non-`const` widget is created again on every `build`.
- **Solution:** every static widget is `const`, so Flutter reuses the same instance and skips rebuilding it. The themes (`AppTheme.light` / `AppTheme.dark`) are built once and reused.
- **Enforcement:** `analysis_options.yaml` raises `prefer_const_constructors` to a warning, so any missing `const` shows up in `flutter analyze`.

### 1.2 Avoiding unnecessary rebuilds

| Place | Common approach | What this app does |
| --- | --- | --- |
| Products screen | The whole screen watches the state, so the app bar and search field rebuild with every new page | `ProductsScreen` watches nothing; only `_ProductList` watches the state |
| Favourite button | Every card rebuilds when one favourite changes | `isFavoriteProvider(id)` with `select`: only one button rebuilds |
| Auth gate | Rebuilds on any change to the auth state | `select((s) => s.status)`: rebuilds only when the status changes |
| Clear-search button | `setState` on the whole screen for every keystroke | `ValueListenableBuilder` rebuilds only the icon |
| Switching tabs | The screen is recreated and loses its scroll position | `IndexedStack` keeps each tab alive |

**How to verify:** in Flutter DevTools open the Flutter Inspector and enable "Highlight Repaints", or enable "Track widget rebuilds" and watch the rebuild counts while tapping a product's heart.

### 1.3 ListView.builder

- **Problem:** `Column` or `ListView(children: [...])` builds every item up front, including the ones off screen.
- **Solution:** the product list and the favourites list use `ListView.builder`, which builds only the visible rows. Each card has a `ValueKey(product.id)`.
- The details page uses `PageView.builder`, so an image is loaded only when the user swipes to it.

### 1.4 Image caching

`AppNetworkImage` (in `core/widgets`) wraps `cached_network_image`:

- **Disk:** an image is downloaded once and kept between app launches.
- **Memory:** `memCacheWidth` decodes the image at the size it is displayed. A thumbnail shown 88 logical pixels wide is not held in memory at full resolution.
- A placeholder of the same size is shown while loading, so list items do not jump.

### 1.5 Lazy loading

| What is deferred | How |
| --- | --- |
| Product data | 20 products per request (`AppConstants.pageSize`); the next page is requested 400 px before the end of the list |
| API fields | `select=...` requests only the fields the app displays |
| Tabs | The Favourites and Profile tabs are built the first time they are opened |
| Database | Opened on the first read of the favourites |
| Startup | No `await` before `runApp`; the first frame appears immediately |

### 1.6 Networking

- One shared `Dio` client (a single connection pool) through `dioProvider`.
- Search is debounced by 400 ms (`Debouncer`), and the previous request is cancelled with a `CancelToken` when the user keeps typing.
- When loading a page fails, the request is not retried on every scroll event; a "Try again" button is shown instead.

### 1.7 Measuring runtime performance

```bash
flutter run --profile
```

Open DevTools > Performance and record while scrolling the product list to inspect frame times and jank.

## 2. App size

### 2.1 Removing unused resources

- No unused packages in `pubspec.yaml` (7 packages, all in use). `cupertino_icons` is not included.
- `assets/` contains only 4 SVG files, all in use.
- R8 is enabled in `android/app/build.gradle.kts`: `isMinifyEnabled = true` and `isShrinkResources = true`.
- Flutter removes unused Material icons from the icon font in release builds (icon tree shaking).

### 2.2 Image compression (measured)

The only raster images are the launcher icon and the splash logo for older devices (10 PNG files). They were compressed by converting them to a 64-colour palette:

| | Size |
| --- | --- |
| Before | 55,922 bytes |
| After | 17,989 bytes |
| Saved | 68% |

### 2.3 SVG instead of raster images

The logo and the empty/error illustrations are SVG files totalling 2,268 bytes. They stay sharp on every screen without multiple density variants (mdpi/hdpi/...). On Android 8+ the launcher icon is also a vector (adaptive icon).

### 2.4 Splitting APKs by ABI (measured)

```bash
flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/symbols
```

Instead of one APK that carries native code for every CPU architecture, each device downloads only the APK for its own architecture:

| File | Size |
| --- | --- |
| `app-armeabi-v7a-release.apk` | 14.3 MB |
| `app-arm64-v8a-release.apk` | 17.0 MB |
| `app-x86_64-release.apk` | 18.4 MB |

`--obfuscate --split-debug-info` also moves the Dart debug symbols out of the APK into `build/symbols`.

### 2.5 Analyzing the app size (measured)

```bash
flutter build apk --analyze-size --target-platform android-arm64
```

| Component | Size |
| --- | --- |
| `app-release.apk` (arm64, total compressed) | 18 MB |
| `lib/arm64-v8a` (Flutter engine + compiled Dart code) | 17 MB |
| Dart AOT code (decompressed) | 6 MB |
| of which `package:flutter` | 3 MB |
| of which `package:shoplite` (the app's own code) | 70 KB |
| `classes.dex` (Java/Kotlin code after R8) | 355 KB |
| `assets/flutter_assets` (SVGs, fonts) | 109 KB |

Almost all of the size is the Flutter engine, which every Flutter app ships. The app's own code and assets add under 200 KB, so there is nothing left to trim on the app side. The analyzed build is 18.2 MB; adding `--obfuscate --split-debug-info` brings the same architecture down to 17.0 MB (section 2.4).

The command prints a size breakdown and saves a JSON file that can be opened in DevTools > App Size.