# Best Practices Checklist

Legend: ✅ done · 🔲 still to do

## Performance optimization

| | Item | Where |
| --- | --- | --- |
| ✅ | Use const constructors | All static widgets + lints in `analysis_options.yaml` |
| ✅ | Avoid unnecessary rebuilds | `select`, `isFavoriteProvider`, `_ProductList`, `ValueListenableBuilder`, `IndexedStack` |
| ✅ | ListView.builder for long lists | `products_screen.dart`, `favorites_screen.dart` |
| ✅ | Image caching | `core/widgets/app_network_image.dart` |
| ✅ | Lazy loading | `products_controller.dart` (pagination), `home_shell.dart`, `app_database.dart` |

## App size optimization

| | Item | Where |
| --- | --- | --- |
| ✅ | Remove unused resources | No unused assets or packages + `isShrinkResources` |
| ✅ | Compress images | Launcher and splash PNGs: 55,922 to 17,989 bytes |
| ✅ | Use vector graphics (SVG) | `assets/icons/*.svg` + `ic_launcher_foreground.xml` |
| ✅ | Split APKs by ABI | `--split-per-abi`: 14.3 MB / 17.0 MB / 18.4 MB |
| 🔲 | Analyze app bundle | `flutter build apk --analyze-size --target-platform android-arm64` |

## Code organization

| | Item | Where |
| --- | --- | --- |
| ✅ | Feature-based folder structure | `lib/features/{auth,products,favorites,profile,home}` |
| ✅ | Separate concerns | `data` / `logic` / `presentation` inside each feature |
| ✅ | Reusable widgets | `core/widgets/` (5 widgets) + `ProductCard` and `FavoriteButton` |
| ✅ | Constants file | `core/constants/app_constants.dart`, `app_strings.dart`, `app_assets.dart` |
| ✅ | Theme file | `core/theme/app_theme.dart`, `app_colors.dart` (light + dark) |

## Best practices

| | Item | Where |
| --- | --- | --- |
| ✅ | Null safety | Dart 3 sound null safety; no `!` on API data; models read every field defensively |
| ✅ | Error handling everywhere | `ApiException` for all network errors, `try/catch` in every controller, global handlers in `main.dart` |
| ✅ | Loading states | Initial load, loading more pages, sign-in button, log out, app startup |
| ✅ | Proper disposal | `dispose()` for every controller, `FocusNode`, `ScrollController` and `Debouncer`; `CancelToken`, `Dio` and the database are closed |
| ✅ | Accessibility labels | `tooltip` on every icon button, `Semantics` on product cards and images, `semanticsLabel` on progress indicators, visible field labels, 48dp touch targets |

## Security practices

| | Item | Where |
| --- | --- | --- |
| ✅ | Secure storage for secrets | `core/storage/secure_storage_service.dart` + `allowBackup="false"` |
| ✅ | HTTPS only | `core/network/api_client.dart` + `network_security_config.xml` + `usesCleartextTraffic="false"` |
| ✅ | Input validation | `core/utils/validators.dart` + `Form` in `login_screen.dart` |
| ✅ | SQL injection prevention | `favorites_repository.dart` (bound parameters only) |

## Prepare for production

| | Item | Where |
| --- | --- | --- |
| ✅ | App icons and splash screen | `android/app/src/main/res/` |
| ✅ | App name and package name | ShopLite / `com.shoplite.app` |
| ✅ | Version numbers | `version: 1.0.0+1` in `pubspec.yaml` |
| ✅ | Release build configuration | `android/app/build.gradle.kts` (R8 + signing) |

## Build release APK

| | Item | How |
| --- | --- | --- |
| ✅ | Generate signing key | `keytool`, stored as `android/app/upload-keystore.jks` (git-ignored, never shared) |
| ✅ | Configure signing | `build.gradle.kts` reads `android/key.properties` (template: `key.properties.example`) |
| ✅ | Build release APK | `flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/symbols` |
| ✅ | Test release build | Run on a Pixel 7a emulator (API 36): sign in, product list, search, details, favourites |

## Automated checks

| | Check | Command |
| --- | --- | --- |
| ✅ | Static analysis | `flutter analyze` |
| ✅ | Unit tests (3 files) | `flutter test` |