# Flutter Package Explorer

A practical Flutter project for learning and demonstrating popular Flutter packages, GetX, common utilities, networking, local storage, data modeling, and navigation.

## 1. Learning Objectives

- Explore popular Flutter packages.
- Learn the GetX framework.
- Use utility packages.
- Implement common Flutter features.
- Understand when to use different packages and their alternatives.

## 2. Learning Resources

### YouTube Search Terms
- Flutter GetX tutorial
- Best Flutter packages 2024
- Flutter useful packages
- GetX state management
- Flutter package recommendations

### Recommended Channels
- The Flutter Way
- Reso Coder
- Marcus Ng

### Package Tutorials
The task includes approximately 3 hours of package/tutorial learning covering GetX, Freezed, GoRouter, Dio, Hive and useful Flutter packages.

## 3. Package 1 — GetX

**Package:** `get: ^4.7.2`

### Covered
- Installation
- Reactive state management
- `.obs`
- `Obx`
- Dependency injection
- `Get.put`
- `Get.find`
- Navigation concepts
- When to use GetX

### App Demonstration
The GetX screen demonstrates a reactive counter, reactive package selection, dependency injection, and navigation to a details screen.

### Alternatives
Provider, Riverpod, Bloc.

### Recommendation
GetX is convenient for lightweight reactive state management and dependency injection, especially in small/medium applications or rapid development.

## 4. Package 2 — Freezed

**Packages:** `freezed_annotation`, `freezed`, `json_annotation`, `json_serializable`

### Covered
- Immutable classes
- `@freezed`
- `copyWith`
- Union/result states
- JSON serialization
- Generated code

### App Demonstration
The Product model demonstrates immutable data, `copyWith`, JSON conversion and generated serialization.

Generated files:
```text
product.freezed.dart
product.g.dart
```

Generate them with:
```bash
dart run build_runner build
```

### Alternatives
Manual Dart classes, Equatable, Built Value.

## 5. Package 3 — GoRouter

**Package:** `go_router: ^16.2.1`

### Covered
- Installation
- Declarative routing
- Route paths
- Route parameters/deep-link concepts
- Back navigation
- Typed-route concepts using `GoRouteData` / `go_router_builder`

### App Routes
```text
/
/getx
/getx-details
/freezed
/router
/dio
/hive
/utilities
```

### Alternatives
Flutter Navigator, GetX Navigation, AutoRoute.

### Recommendation
GoRouter is suitable for structured navigation, deep links and scalable route configuration.

## 6. Package 4 — Dio

**Package:** `dio: ^5.9.0`

### Covered
- HTTP requests
- GET requests
- Loading/error handling
- Interceptors
- Request cancellation
- File downloads
- Comparison with `http`

### Dio vs http

| Feature | Dio | http |
|---|---|---|
| Basic requests | Yes | Yes |
| Interceptors | Yes | Manual |
| Cancellation | Yes | Less convenient |
| Downloads | Yes | More manual |
| Progress | Yes | More manual |
| Advanced configuration | Yes | Simpler |

**Recommendation:** use `http` for simple APIs and Dio when advanced networking features are required.

## 7. Package 5 — Hive

**Packages:** `hive`, `hive_flutter`

### Covered
- Installation
- Hive initialization
- Box concept
- Create
- Read
- Update
- Delete
- Clear
- Local persistence
- Hive vs SQLite

### Hive vs SQLite

| Feature | Hive | SQLite |
|---|---|---|
| Type | NoSQL/key-value | Relational |
| Setup | Simple | More involved |
| SQL | No | Yes |
| CRUD | Simple | SQL |
| Relationships | Limited | Excellent |
| Lightweight storage | Excellent | Good |

**Recommendation:** Hive is suitable for lightweight local object/key-value storage; SQLite is better for relational data and complex queries.

## 8. Utility Packages

### intl
`intl: ^0.20.2`

Used for date, number and currency formatting.

### url_launcher
`url_launcher: ^6.3.2`

Used to open external URLs.

### share_plus
`share_plus: ^12.0.1`

Used to share content through the device's native share functionality.

### connectivity_plus
`connectivity_plus: ^7.0.0`

Used to check and monitor network connectivity.

## 9. Application Screens

### Home
Provides access to all package examples.

### GetX
- Reactive counter
- `Obx`
- `.obs`
- Dependency injection
- Reactive package selection
- Details navigation

### Freezed
- Immutable Product model
- `copyWith`
- JSON serialization
- Generated code
- Result/union states

### GoRouter
- Declarative navigation
- Route paths
- Deep-link/parameter concepts
- Back navigation
- Typed-route concepts

### Dio
- HTTP request
- Loading state
- Error handling
- Interceptor
- Cancellation
- Download

### Hive
- Local storage
- Box
- CRUD
- Persistence

### Utilities
- Date/currency formatting
- Open URL
- Native sharing
- Network status

## 10. Package Comparison

### State Management

| Package | Strength | Best Use |
|---|---|---|
| GetX | Simple/reactive + DI | Small/medium and rapid development |
| Provider | Simple | Straightforward state management |
| Riverpod | Scalable/testable | Medium/large apps |
| Bloc | Structured/predictable | Complex applications |

### Navigation

| Solution | Strength | Best Use |
|---|---|---|
| GoRouter | Declarative + deep links | Modern scalable Flutter apps |
| Navigator | Native | Simple navigation |
| GetX Navigation | Very concise | Apps already using GetX |
| AutoRoute | Generated routes | Complex routing |

### Networking

| Package | Strength | Best Use |
|---|---|---|
| Dio | Interceptors/cancellation/downloads | Advanced APIs |
| http | Simple | Basic API calls |

### Local Storage

| Package | Strength | Best Use |
|---|---|---|
| Hive | Lightweight NoSQL | Local objects/key-value data |
| SQLite | Relational | Complex queries/relationships |
| SharedPreferences | Simple key-value | Settings/preferences |

### Data Models

| Solution | Strength | Best Use |
|---|---|---|
| Freezed | Immutable + unions + code generation | Modern data models |
| Manual classes | Simple/no generation | Small projects |
| Equatable | Value equality | Comparing state/models |

## 11. How Packages Work Together

```text
Flutter UI
 ├── GetX
 │   └── State management / DI
 ├── GoRouter
 │   └── Navigation
 ├── Dio
 │   └── HTTP/API
 ├── Freezed
 │   └── Immutable models / JSON
 ├── Hive
 │   └── Local persistence
 └── Utilities
     ├── intl
     ├── url_launcher
     ├── share_plus
     └── connectivity_plus
```

The application uses more than three packages together and demonstrates each package through practical features.

## 12. Project Structure

```text
flutter_package_explorer/
├── lib/
│   ├── controllers/
│   │   └── app_controller.dart
│   ├── models/
│   │   ├── product.dart
│   │   ├── product.freezed.dart
│   │   └── product.g.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── getx_screen.dart
│   │   ├── freezed_screen.dart
│   │   ├── router_screen.dart
│   │   ├── dio_screen.dart
│   │   ├── hive_screen.dart
│   │   └── utilities_screen.dart
│   ├── services/
│   │   └── hive_service.dart
│   └── main.dart
├── docs/
├── assets/
├── pubspec.yaml
└── README.md
```

## 13. Main Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  get: ^4.7.2
  freezed_annotation: ^3.1.0
  json_annotation: ^4.9.0
  go_router: ^16.2.1
  dio: ^5.9.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  intl: ^0.20.2
  url_launcher: ^6.3.2
  share_plus: ^12.0.1
  connectivity_plus: ^7.0.0
```

Development dependencies include Flutter test/lints, build_runner, Freezed and JSON serialization tools. If typed-route generation is enabled, `go_router_builder` is also used.

## 14. Installation and Running

```bash
flutter pub get
dart run build_runner build
flutter run
```

## 15. Common Features Demonstrated

- Reactive UI
- Dependency injection
- Navigation and back navigation
- API communication
- Loading and error states
- Request cancellation
- File downloading
- Local persistence
- CRUD
- Date and currency formatting
- URL launching
- Content sharing
- Connectivity monitoring
- Immutable models
- JSON serialization


## 16. Deliverables

### App using multiple packages
Completed through the Flutter Package Explorer application.

### GetX example
Included in the GetX screen.

### Dio HTTP client
Included in the Dio screen.

### Hive database example
Included in the Hive screen.

### Package comparison document
Included in this README/documentation, covering GetX, GoRouter, Dio, Hive, Freezed and alternatives.

### README with recommendations
This README includes package descriptions, comparisons, recommendations, setup, project structure, testing and deliverables.

## 17. Package Recommendations

**GetX:** useful for lightweight reactive state management and dependency injection.

**Freezed:** useful for immutable models, JSON serialization and union/result states.

**GoRouter:** useful for declarative routing, structured navigation and deep links.

**Dio:** useful for advanced API communication, interceptors, cancellation and downloads.

**Hive:** useful for lightweight local persistence without SQL.

**intl:** recommended for date/number/currency formatting.

**url_launcher:** recommended for opening external URLs.

**share_plus:** recommended for native content sharing.

**connectivity_plus:** recommended for monitoring network connectivity.

## 18. Final Learning Outcome

The project focuses on understanding what each package solves, how to integrate it, how it compares with alternatives, and when it should be used.

The main technologies explored are:

```text
GetX
Freezed
GoRouter
Dio
Hive
intl
url_launcher
share_plus
connectivity_plus
```

## 19. Requirement Summary

| Requirement | Status |
|---|---|
| Explore popular Flutter packages | Completed |
| Learn GetX | Completed |
| GetX state management | Completed |
| GetX navigation concepts | Completed |
| GetX dependency injection | Completed |
| When to use GetX | Documented |
| Freezed installation | Completed |
| Immutable classes | Completed |
| Union/result types | Completed |
| JSON serialization | Completed |
| GoRouter installation | Completed |
| Declarative routing | Completed |
| Deep linking/route concepts | Completed |
| Typed routes | Included/implemented as a GoRouter feature |
| Dio installation | Completed |
| Dio interceptors | Completed |
| File downloads | Completed |
| Request cancellation | Completed |
| Dio vs http | Documented |
| Hive installation | Completed |
| Box concept | Completed |
| CRUD | Completed |
| Hive vs SQLite | Documented |
| intl | Completed |
| url_launcher | Completed |
| share_plus | Completed |
| connectivity_plus | Completed |
| 3+ packages in one app | Completed |
| Demonstrate packages | Completed |
| Compare alternatives | Completed |
| Package comparison document | Completed |
| README with recommendations | Completed |
| GetX example | Completed |
| Dio HTTP client | Completed |
| Hive database example | Completed |

## Conclusion

Flutter Package Explorer is a practical package-learning application that combines commonly used Flutter packages and demonstrates their main features through dedicated examples.

The project is designed as a practical reference rather than only a tutorial: each package is connected to a real feature, compared with alternatives, and accompanied by a recommendation for when it is appropriate.
