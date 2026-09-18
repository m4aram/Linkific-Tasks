Flutter Navigation Demo — Project Documentation

Project Status

The Flutter navigation project has been implemented and the main
navigation features have been tested successfully.

Completed and Tested

1. Home screen works.
2. Home button works.
3. The advertisement appears when the Home button is pressed.
4. Bottom Navigation works.
5. Explore screen works.
6. Featured section works.
7. Categories section works.
8. Favorites section works.
9. Profile screen works.
10. Settings route is configured.
11. About route is configured.
12. Details route is configured.
13. Navigation between screens works.
14. Back navigation works.
15. Application tested on Pixel 7a API 36 Android Emulator.



Main Screens

The application contains three main screens in the bottom navigation:

1. Home
2. Explore
3. Profile



Explore Screen

The Explore screen contains three sections:

Featured

Displays the featured content.

Categories

Displays the categories content.

Favorites

Displays the favorites content.

The three sections were tested and the selected section changes
correctly.



Home Screen

The Home screen contains the main Home content and its action button.

The button was tested successfully. When the button is pressed, the
related action is executed and the advertisement appears according to
the current application behavior.



Profile Screen

The Profile screen is accessible through the Bottom Navigation and was
tested successfully.



Additional Routes

The application includes the following named routes:

● /
● /profile
● /settings
● /about

The Details screen is also included for displaying item details and
passing route arguments when required.



Project Structure

```text
lib/
├── main.dart
├── models/
│   └── route_arguments.dart
├── navigation/
│   └── bottom_navigation_screen.dart
└── screens/
    ├── about_screen.dart
    ├── details_screen.dart
    ├── drawer_screen.dart
    ├── explore_screen.dart
    ├── home_screen.dart
    ├── nested_details_screen.dart
    ├── profile_screen.dart
    └── settings_screen.dart
```



Navigation Implementation

The Bottom Navigation is implemented in:
lib/navigation/bottom_navigation_screen.dart

The current selected page is controlled by:
on

Project Status
dart
_currentIndex

The pages are displayed using:

dart
 IndexedStack(
  index: _currentIndex,
  children: pages,
)

The selected navigation destination updates _currentIndex.



Main Application

The application entry point is:
lib/main.dart

The application uses MaterialApp and defines the named routes.

The initial route is:
/text

which opens the Home screen.



Route Arguments

Route-related data is handled through:
lib/models/route_arguments.dart

This file is used when data needs to be passed between screens.



Testing Checklist

Navigation

1. Application opens on Home.
2. Bottom Navigation is visible.
3. Home navigation works.
4. Explore navigation works.
5. Profile navigation works.
6. Navigation between screens works.
7. Back navigation works.

Explore

1. Featured works.
2. Categories works.
3. Favorites works.
4. Selected tab changes correctly.

Home

1. Home content is displayed.
2. Home button works.
3. Button action works.
4. Advertisement appears after the button action.

Routes

1. Home route.
2. Profile route.
3. Settings route.
4. About route.
5. Details screen.

Device Testing

1. Pixel 7a API 36 Android Emulator.


How to Run

Install dependencies:
flutter pub get

Run the application:
o — Project Documentation
Or run it directly from Android Studio 

Before final submission, it is recommended to run:
flutter analyze

and then:
flutter run


Technologies Used

● Flutter
● Dart
● Material Design
● MaterialApp
● NavigationBar
● IndexedStack
● Named Routes
● Stateful Navigation
● Android Emulator



Final Status

The main navigation flow and the tested application features are working
according to the current tests.

The project is ready for the next testing/documentation stage.