# Flutter Package Explorer

A practical Flutter project created to explore popular Flutter packages,
understand when to use them, and implement common features through
working examples.

## Learning Objectives

-   Explore popular Flutter packages.
-   Learn GetX framework.
-   Understand practical utility packages.
-   Implement common Flutter features using packages.
-   Compare packages with common alternatives.
-   Build one application that demonstrates multiple packages together.

------------------------------------------------------------------------

## Packages Covered

### 1. GetX

GetX is demonstrated for:

-   State management.
-   Reactive state using `.obs` and `Obx`.
-   Dependency injection using `Get.put()` and `Get.find()`.
-   Navigation between screens.
-   Returning to previous screens.

#### When to use GetX

GetX can be useful when a Flutter application needs a compact solution
for reactive state management, dependency injection, and navigation.

------------------------------------------------------------------------

### 2. Freezed

Freezed is demonstrated for:

-   Immutable data classes.
-   `copyWith`.
-   Value equality.
-   Generated model code.
-   JSON serialization.
-   Union/sealed result types.

Generated files are produced using `build_runner`.

Example generation command:

``` bash
dart run build_runner build --delete-conflicting-outputs
```

#### When to use Freezed

Freezed is useful when an application contains many immutable models,
API responses, JSON models, or multiple states/results that benefit from
generated Dart code.

------------------------------------------------------------------------

### 3. GoRouter

GoRouter is demonstrated for:

-   Declarative routing.
-   Centralized route configuration.
-   Route parameters.
-   Details pages.
-   Navigation and back navigation.
-   Deep-link-ready route structure.

#### When to use GoRouter

GoRouter is useful when an application has multiple screens, nested
routes, route parameters, deep links, or a larger navigation structure.

------------------------------------------------------------------------

### 4. Dio

Dio is demonstrated as an advanced HTTP client with:

-   `BaseOptions`.
-   Connection and receive timeouts.
-   Interceptors.
-   GET requests.
-   Error handling.
-   `CancelToken`.
-   Request cancellation.
-   File downloading.

#### When to use Dio

Dio is useful when an application needs more advanced HTTP functionality
than a basic HTTP client, especially interceptors, centralized
configuration, cancellation, timeouts, and downloads.

------------------------------------------------------------------------

### 5. Hive

Hive is demonstrated as a lightweight local NoSQL database with:

-   Boxes.
-   Create operations.
-   Read operations.
-   Update operations.
-   Delete operations.
-   Clearing stored data.
-   Local persistence.

#### When to use Hive

Hive is useful for lightweight local storage when a relational database
is unnecessary and fast key-value/NoSQL persistence is sufficient.

------------------------------------------------------------------------

## Utility Packages

### intl

Used for:

-   Date formatting.
-   Currency formatting.
-   Localized number/date presentation.

Example output:

``` text
October 5, 2026 1:11 AM
$1,234.56
```

### url_launcher

Used to open an external URL such as Flutter's website in the device
browser.

### share_plus

Used to share text through the native Android sharing interface.

### connectivity_plus

Used to read the current network connectivity status such as Wi-Fi,
mobile data, or no connection.

------------------------------------------------------------------------

# Practical Application Demonstrations

The application contains separate demonstrations for the packages while
combining multiple packages in one Flutter project.

## GetX Demonstration

The GetX screen demonstrates:

1.  Counter state management.
2.  Reactive state with `.obs` and `Obx`.
3.  Dependency injection.
4.  Controller access.
5.  Navigation to a details screen.
6.  Returning from the details screen.

Expected behavior:

``` text
Counter: 0
Increment
```

Pressing Increment changes the counter reactively.

The dependency injection section displays the active controller
instance.

The reactive package selection changes immediately when a different
package is selected.

The navigation button opens a details page and the back action returns
to the GetX example.

------------------------------------------------------------------------

## Freezed Demonstration

The Freezed example demonstrates an immutable Product model and
generated functionality.

The project includes:

-   Immutable model definition.
-   Generated `copyWith`.
-   Equality.
-   JSON serialization.
-   Union/sealed result states.

The generated Freezed files are kept separate from the manually written
model.

------------------------------------------------------------------------

## GoRouter Demonstration

The GoRouter example demonstrates centralized declarative navigation.

The project includes:

-   Application routes.
-   Route parameters.
-   Product details navigation.
-   Back navigation.
-   A structure suitable for deep linking.

Example:

``` text
/products/42
```

The details screen receives and displays the product ID.

------------------------------------------------------------------------

## Dio Demonstration

The Dio screen demonstrates an advanced HTTP client.

Features demonstrated:

``` text
BaseOptions
Timeouts
Interceptors
GET requests
Loading state
Error handling
CancelToken
Request cancellation
download()
```

The user can start a request, cancel it, and trigger a file download.

------------------------------------------------------------------------

## Hive Demonstration

The Hive screen demonstrates complete local CRUD functionality.

### Create

Enter a note title and create a new record.

### Read

Saved notes are displayed from the Hive box.

### Update

An existing note can be selected for editing and its title can be
updated.

### Delete

A note can be deleted from the local database.

### Clear

Stored data can be cleared.

### Persistence

Hive data remains available after closing and reopening the application.

------------------------------------------------------------------------

# Package Comparison

The following comparison is included **inside this README as required
documentation**, rather than as a separate application page.

  ---------------------------------------------------------------------------------------------
Package                 Main Purpose   Strengths       Common Alternative   When to Choose It
  ----------------------- -------------- --------------- -------------------- -----------------
**GetX**                State          Compact API,    Riverpod / Provider  Small to medium
management,    reactive state,                      apps or teams
DI, navigation built-in                             that prefer a
DI/navigation                        concise
all-in-one
approach

**Freezed**             Immutable      Code            Manual Dart models   API-heavy
models and     generation,                          applications with
unions         `copyWith`,                          many models and
equality,                            states
JSON/union                           
support

**GoRouter**            Navigation and Declarative     Navigator 1.0 /      Apps with
routing        routing, route  Navigator 2.0        structured or
parameters,                          complex
deep-link                            navigation
support

**Dio**                 HTTP client    Interceptors,   `http`               Apps requiring
cancellation,                        advanced
timeouts,                            networking
downloads                            features

**Hive**                Local NoSQL    Lightweight,    SQLite /             Simple local
storage        fast, simple    shared_preferences   persistence and
CRUD                                 key-value/NoSQL
data

**intl**                Formatting and Date, number,   Manual formatting    Localized
localization   and currency                         presentation of
formatting                           dates, numbers,
and currencies

**url_launcher**        Open external  Simple platform Manual platform code Opening websites,
URLs           URL launching                        email links,
phone links, etc.

**share_plus**          Native sharing Easy platform   Platform-specific    Sharing
share           sharing code         text/content
integration                          through installed
apps

**connectivity_plus**   Network        Simple          Platform-specific    Displaying or
connectivity   connectivity    APIs                 reacting to
status access                        network
connection status
  ---------------------------------------------------------------------------------------------

## Package Recommendations

### State Management

For a project that needs a compact combination of reactive state,
dependency injection, and navigation, GetX is a practical option.

For larger applications where state management needs to remain strongly
separated from the widget tree and testing is a major priority, Riverpod
can be a stronger alternative.

### Data Models

Use Freezed when the application contains many immutable models, API
responses, JSON serialization, or multiple result states.

### Navigation

Use GoRouter when routing needs to be centralized and the application
uses route parameters or deep links.

### Networking

Use Dio when the application needs interceptors, cancellation, timeouts,
downloads, or centralized HTTP configuration. For very simple requests,
`http` may be sufficient.

### Local Storage

Use Hive for lightweight local NoSQL/key-value-style persistence.
Consider SQLite when the application requires relational queries and
structured database relationships.

### Utility Packages

Use the utility package that directly matches the required feature
rather than adding packages that are not needed.

------------------------------------------------------------------------

# Project Structure

``` text
lib/
├── controllers/
│   └── app_controller.dart
│
├── models/
│   ├── product.dart
│   ├── product.freezed.dart
│   └── product.g.dart
│
├── screens/
│   ├── home_screen.dart
│   ├── getx_screen.dart
│   ├── freezed_screen.dart
│   ├── router_screen.dart
│   ├── dio_screen.dart
│   ├── hive_screen.dart
│   └── utilities_screen.dart
│
├── services/
│   ├── hive_service.dart
│   └── dio_service.dart
│
└── main.dart
```

Generated Freezed files are not manually edited.

------------------------------------------------------------------------

# Installation and Setup

Install dependencies with:

``` bash
flutter pub get
```

Generate Freezed files with:

``` bash
dart run build_runner build --delete-conflicting-outputs
```

Run the application with:

``` bash
flutter run
```

For a clean rebuild if required:

``` bash
flutter clean
flutter pub get
flutter run
```

------------------------------------------------------------------------


# Deliverables

The project covers the requested deliverables:

-   App using multiple Flutter packages.
-   GetX example.
-   Freezed data model example.
-   GoRouter navigation example.
-   Dio HTTP client example.
-   Hive database example.
-   Utility package demonstrations.
-   Package comparison and recommendations **documented in this
    README**.
-   README with package recommendations and implementation details.

------------------------------------------------------------------------

# Execution Result

The Flutter Package Explorer was implemented as a practical
demonstration project for popular Flutter packages.

The project demonstrates GetX state management, dependency injection and
navigation; Freezed immutable models and generated code; GoRouter
declarative routing; Dio advanced HTTP functionality; Hive local NoSQL
CRUD; and utility packages for formatting, URLs, sharing, and
connectivity.

The application was run on an Android emulator and the main package
demonstrations were verified through practical interaction.

The project documentation also includes a package comparison and
recommendations to explain when each package is appropriate and which
alternatives can be considered.
