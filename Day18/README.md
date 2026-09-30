# Flutter REST API Integration

A Flutter app that consumes the public [JSONPlaceholder](https://jsonplaceholder.typicode.com) REST API.
It demonstrates HTTP requests, JSON parsing, error handling, and loading states.

## Features

- List of posts (GET) with **search** and **pull-to-refresh**
- Detail screen with the author (nested JSON) and comments
- Create (POST), update (PUT), partial update (PATCH) and delete (DELETE)
- Loading indicator, error messages and a **Retry** button
- Timeout, no-internet and HTTP status-code handling

## Getting started

```bash
flutter create .          # generates android/ios/web folders (run once)
flutter pub get
flutter run
```

Requires Flutter 3.22+ (uses `PopScope.onPopInvokedWithResult`).

## Project structure

```
lib/
├── main.dart
├── models/            # Post, Comment, User (+ Address, Geo, Company)
├── services/          # api_service.dart - all HTTP logic lives here
├── screens/           # posts list, post detail, create/edit form
└── widgets/           # reusable ErrorView
```

## API integration guide

### 1. Install the package

```yaml
dependencies:
  http: ^1.2.2
```

### 2. HTTP methods used

| Method | Endpoint          | Where in the app            |
|--------|-------------------|-----------------------------|
| GET    | `/posts`          | Posts list                  |
| GET    | `/users/{id}`     | Detail screen (author)      |
| GET    | `/comments?postId=` | Detail screen (comments)  |
| POST   | `/posts`          | New post form               |
| PUT    | `/posts/{id}`     | Edit form                   |
| PATCH  | `/posts/{id}`     | Quick rename dialog         |
| DELETE | `/posts/{id}`     | Delete action in detail     |

**Headers** are set once (`Content-Type`, `Accept`).
**Query parameters** are built with `Uri.replace(queryParameters: {...})`,
e.g. `/posts?_page=1&_limit=100`.

### 3. JSON parsing

Each model has `fromJson` / `toJson`.

```dart
factory Post.fromJson(Map<String, dynamic> json) => Post(
  userId: json['userId'] as int,
  id: json['id'] as int,
  title: json['title'] as String,
  body: json['body'] as String,
);
```

Nested JSON is handled by delegating to child models:
`User.fromJson` -> `Address.fromJson` -> `Geo.fromJson`, and `Company.fromJson`.

### 4. Error handling

`ApiService._send` wraps every request and converts failures to `ApiException`:

| Problem              | Handled with                |
|----------------------|-----------------------------|
| Slow / no response   | `.timeout(10s)` -> `TimeoutException` |
| No internet          | `SocketException`, `http.ClientException` |
| Non-2xx status code  | Status check -> readable message (404, 5xx, ...) |
| Bad JSON             | `FormatException` |

The UI only needs `try { ... } on ApiException catch (e) { ... }`.

### 5. Loading states

Each screen has three states: **loading** (spinner), **error** (message + Retry),
and **data**. Pull-to-refresh keeps old data visible and shows a SnackBar if the refresh fails.

## Notes

JSONPlaceholder is a fake API: POST/PUT/PATCH/DELETE return success but **do not
persist** data, so the app updates its local list after each successful call.
Editing a post you just created (id 101) will fail with a server error because it
doesn't really exist on the server - this is expected, and shows the error handling working.

## Possible extensions

- Use the `dio` package (interceptors, cancel tokens)
- Add `json_serializable` for generated parsing code
- Try the REST Countries API or a Weather API by adding a new service + models

## Additional APIs

The app now consumes **three** public APIs:

| API | Used for | API key |
|-----|----------|---------|
| [JSONPlaceholder](https://jsonplaceholder.typicode.com) | Posts, comments, users (full CRUD) | No |
| [REST Countries](https://restcountries.com) | Countries list, server-side search, country details | No |
| [Open-Meteo](https://open-meteo.com) | Current weather of the country's capital | No |

### Countries feature

- `GET /v3.1/all?fields=...` loads the list. REST Countries requires the `fields` query parameter (max 10 fields).
- `GET /v3.1/name/{name}?fields=...` is used for search. The search box is **debounced** (400 ms) so the API is called only after the user stops typing. A `404` response means "no results" and is handled as an empty list, not as an error.
- The detail screen reads the capital's coordinates from the first API (`capitalInfo.latlng`) and passes them to Open-Meteo: `GET /v1/forecast?latitude=..&longitude=..&current=temperature_2m,wind_speed_10m,weather_code`.
- Weather has its own loading / error / retry state, independent from the rest of the screen.

### Extra files

```
lib/models/country.dart              # nested JSON, lists and maps -> Country
lib/models/weather.dart              # Open-Meteo response -> Weather
lib/services/countries_service.dart  # REST Countries + Open-Meteo calls
lib/screens/countries_screen.dart    # list + debounced search + pull-to-refresh
lib/screens/country_detail_screen.dart
```
