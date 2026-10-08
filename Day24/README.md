# ShopLite

A Flutter product-catalogue app built to be **production-ready**: optimized performance, small app size, organized code, and clear security practices.

Features: sign-in, a product list with infinite scrolling, search, a product details page, and favourites stored locally in SQLite.

| Document | Contents |
| --- | --- |
| This file | Setup, project structure, optimization guide, building the release APK |
| [docs/PERFORMANCE.md](docs/PERFORMANCE.md) | Performance and size improvements, and how to measure them |
| [docs/BEST_PRACTICES_CHECKLIST.md](docs/BEST_PRACTICES_CHECKLIST.md) | Checklist of every task item and where it is implemented |

## Getting started

Requirements: Flutter 3.27 or newer. Built and run with Flutter 3.47.1 (Dart 3.13.1) on a Pixel 7a emulator (API 36).

```bash
flutter pub get
flutter run
```

Demo account: username `emilys`, password `emilyspass`.

Data comes from the public demo API [dummyjson.com](https://dummyjson.com) over HTTPS. To point the app at another server:

```bash
flutter run --dart-define=API_BASE_URL=https://api.example.com
```

The app refuses any base URL that does not start with `https://`.

> Only the Android platform is configured. To add iOS: `flutter create --platforms=ios .`

## Tech stack

| Package | Used for |
| --- | --- |
| `flutter_riverpod` | State management |
| `dio` | HTTP client |
| `flutter_secure_storage` | Encrypted storage for the auth token |
| `cached_network_image` | Image caching (disk + memory) |
| `sqflite` | Local database for favourites |
| `flutter_svg` | Vector graphics (SVG) |

## Project structure (feature-based)

```
lib/
├── main.dart                 # entry point + global error handlers
├── app.dart                  # MaterialApp and themes
├── core/                     # code shared by every feature
│   ├── constants/            # app_constants / app_strings / app_assets
│   ├── theme/                # app_theme + app_colors (colours, spacing)
│   ├── network/              # Dio client + error-to-message mapping
│   ├── storage/              # secure storage
│   ├── database/             # SQLite connection
│   ├── utils/                # validators + debouncer
│   └── widgets/              # reusable widgets
└── features/
    ├── auth/                 # data / logic / presentation
    ├── products/             # data / logic / presentation
    ├── favorites/            # data / logic / presentation
    ├── profile/
    └── home/                 # bottom navigation shell
```

Each feature is split into three layers (separation of concerns):

- **data**: models and the repository (the only code that talks to the API or the database).
- **logic**: the controller (state and business rules, no widgets).
- **presentation**: screens (render state only, never call the API directly).

## Optimization guide

### 1. Performance

| Technique | How it is applied | File |
| --- | --- | --- |
| `const` constructors | Every static widget is `const`; lint rules flag any missing `const` | `analysis_options.yaml` |
| Avoid unnecessary rebuilds | The screen does not watch state, only the list does. `select` watches a single field. Each heart button watches only its own product | `products_screen.dart`, `favorite_button.dart`, `favorites_controller.dart` |
| `ListView.builder` | Builds only the visible rows, however many products are loaded | `products_screen.dart`, `favorites_screen.dart` |
| Image caching | Disk cache, plus decoding at display size (`memCacheWidth`) | `app_network_image.dart` |
| Lazy loading | 20 products per request while scrolling; tabs built on first open; database opened on first use | `products_controller.dart`, `home_shell.dart`, `app_database.dart` |
| Search debounce | One request 400 ms after typing stops; the previous request is cancelled | `debouncer.dart`, `products_controller.dart` |

### 2. App size

| Technique | How it is applied |
| --- | --- |
| Remove unused resources | No unused packages or assets; `cupertino_icons` not included; R8 (`isMinifyEnabled` + `isShrinkResources`) strips unused code and resources |
| Compress images | Launcher and splash PNGs compressed from 55,922 to 17,989 bytes |
| SVG | Logo and illustrations are SVG (4 files, 2,268 bytes in total); the launcher icon is a vector adaptive icon |
| Split APKs by ABI | `--split-per-abi` produces one APK per CPU architecture: 14.3 MB / 17.0 MB / 18.4 MB |
| Analyze size | `flutter build apk --analyze-size --target-platform android-arm64` |
| `--obfuscate --split-debug-info` | Moves debug symbols out of the APK |

### 3. Security

| Practice | How it is applied | File |
| --- | --- | --- |
| Secure storage | Auth token in `flutter_secure_storage` (encryption key in the Android Keystore); `allowBackup=false` | `secure_storage_service.dart`, `AndroidManifest.xml` |
| HTTPS only | Base URL checked at startup; an interceptor rejects any non-HTTPS request; `usesCleartextTraffic=false` and `network_security_config.xml`; non-HTTPS images are refused | `api_client.dart`, `app_network_image.dart` |
| Input validation | `Form` with validators, a maximum length on every field, sanitized search text | `validators.dart`, `login_screen.dart` |
| SQL injection prevention | Every query uses `?` placeholders with `whereArgs` or sqflite helpers that bind values; no SQL is built from user input | `favorites_repository.dart` |
| No token leakage | The token is sent only to the API host | `api_client.dart` |
| Secrets out of the repo | No keys in source control; `key.properties` and `*.jks` are git-ignored | `android/.gitignore` |

## Production setup

| Item | Value | Where to change it |
| --- | --- | --- |
| App name | ShopLite | `android:label` in `AndroidManifest.xml` |
| Package name | `com.shoplite.app` | `namespace` and `applicationId` in `android/app/build.gradle.kts`, plus the `MainActivity.kt` path |
| Version | `1.0.0+1` | `version` in `pubspec.yaml` (increase the number after `+` for every store upload) |
| App icon | Vector adaptive icon + PNG fallback for older devices | `android/app/src/main/res/mipmap-*` and `drawable/ic_launcher_foreground.xml` |
| Splash screen | Logo on a light/dark background, with Android 12+ support | `drawable/launch_background.xml` and `values*/styles.xml` |
| Release build | R8, resource shrinking, signing | `android/app/build.gradle.kts` |
| Build tools | Gradle 8.14, Android Gradle Plugin 8.11.1, Kotlin 2.2.20, Java 17 | `android/settings.gradle.kts`, `gradle-wrapper.properties` |

## Building the release APK

### 1. Generate a signing key (once)

Windows (PowerShell):

```powershell
keytool -genkey -v -keystore android\app\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

macOS / Linux:

```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Keep a backup of the keystore and its passwords somewhere safe. **Never commit or share it.**

### 2. Configure signing

Copy `android/key.properties.example` to `android/key.properties` and fill in your passwords. `build.gradle.kts` reads it automatically.

Without this file the build is signed with the debug key (fine for testing, not for publishing).

### 3. Build

```bash
flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/symbols
```

Or run analysis, tests and the build in one step: `tool\build_release.bat` (Windows) or `bash tool/build_release.sh`.

Output in `build/app/outputs/flutter-apk/`:

| File | Size | Devices |
| --- | --- | --- |
| `app-arm64-v8a-release.apk` | 17.0 MB | Most modern phones |
| `app-armeabi-v7a-release.apk` | 14.3 MB | Older 32-bit phones |
| `app-x86_64-release.apk` | 18.4 MB | Emulators |

For Google Play, build an App Bundle instead: `flutter build appbundle --release`.

### 4. Test the release build

```bash
flutter run --release
```

Then check: sign in, scroll until more pages load, search, open a product, add and remove a favourite, close and reopen the app (session and favourites persist), airplane mode (clear error message with a retry button), and log out.

### Automatic builds on GitHub

`.github/workflows/release-apk.yml` builds the APKs on every push to `main`; download them from the **Actions** tab under **Artifacts**.

## Tests

```bash
flutter analyze
flutter test
```

The unit tests cover input validation, product parsing (including missing or wrongly-typed data), and mapping network errors to user messages.