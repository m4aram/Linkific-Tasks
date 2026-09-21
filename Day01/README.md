Flutter Setup & First App

Overview

A simple Flutter training project focused on setting up the 
development environment and running a first Flutter application.

Setup
● Flutter SDK installed and added to PATH.
● Android Studio configured for Flutter development.
● Android SDK configured at E:\Android1\Sdk.
● Android SDK tools installed.
● Git installed for version control.
● Flutter environment verified with flutter doctor.

Emulator
● Device: Pixel 7a
● API Level: 36
● Architecture: x86_64
● Emulator successfully connected to Flutter.

Project

Created with:
```bash
flutter create first_app
```

The app was successfully run on the Android emulator using:
**flutter run**

Project Structure:
```text
lib/
├── main.dart
├── screens/
│   └── focus_day_page.dart
└── widgets/
    └── task_card.dart
```
● main.dart — application entry point.
● focus_day_page.dart — main screen and task state.
● task_card.dart — reusable task card widget.
● pubspec.yaml — project configuration and dependencies.

**Flutter Concepts**
The app demonstrates:

● Column
● Row
● Card
● Checkbox
● StatefulWidget
● setState
● Reusable Widgets
● User interaction

Users can check tasks as completed, and the completed task count updates automatically.

Useful Flutter Commands
```bash
flutter doctor
flutter devices
flutter pub get
flutter run
flutter clean
flutter build
```


**Project Result**

The Flutter environment was configured successfully, 
the Android emulator was connected, and the first Flutter application was 
tested successfully.
