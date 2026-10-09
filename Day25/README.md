# FitTrack

A Flutter fitness tracker: workout logging, progress charts, goal setting,
BMI calculator and water intake tracker, with Firebase sign-in and storage.

- State management: Riverpod
- Backend: Firebase Authentication and Cloud Firestore
- Navigation: go_router
- Charts: fl_chart

## Setup

You need the Flutter SDK, Git, a Google account and a GitHub account.
Check Flutter with `flutter doctor`.

### 1. Create the project

```
flutter create --org com.example --platforms android fittrack
cd fittrack
```

Replace `com.example` with your own identifier if you have one.

### 2. Add the starter files

Copy everything from this starter folder into the new `fittrack` folder and
let it replace `lib/main.dart`. Then delete `test/widget_test.dart`, which
tests the default counter app that no longer exists.

### 3. Install the packages

```
flutter pub add flutter_riverpod go_router firebase_core firebase_auth cloud_firestore fl_chart intl
```

### 4. Connect Firebase

1. Open https://console.firebase.google.com and create a project named `fittrack`.
2. In Build > Authentication > Sign-in method, enable Email/Password.
3. In Build > Firestore Database, create a database in production mode.
4. In the Firestore Rules tab, paste the contents of `firestore.rules` and publish.
5. Install the command-line tools and link the app:

```
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
flutterfire configure
```

`flutterfire configure` creates `lib/firebase_options.dart`. The app does
not compile until this file exists.

### 5. Run

```
flutter analyze
flutter test
flutter run
```

You should see a screen titled "Login" with the text "not built yet".

### 6. Put it on GitHub

Create an empty repository named `fittrack` on GitHub (no README, no
.gitignore), then:

```
git init
git add .
git commit -m "chore: initial project setup"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/fittrack.git
git push -u origin main
```

`flutter create` already made a `.gitignore` suited to Flutter.

## Folder structure

```
lib/
  main.dart
  app.dart
  firebase_options.dart        (generated)
  core/
    constants/  router/  theme/  utils/  widgets/
  features/
    auth/  home/  workouts/  progress/  goals/  bmi/  water/  profile/
      data/          repositories and models (only place that imports Firebase)
      application/   Riverpod providers and notifiers
      presentation/  screens and widgets
```

## Git workflow

1. `git checkout main` and `git pull`
2. `git checkout -b feature/<name>`
3. Commit small steps: `feat: ...`, `fix: ...`, `docs: ...`, `refactor: ...`, `test: ...`
4. `git push -u origin feature/<name>`
5. Open a pull request into `main`, complete the checklist, squash and merge.

Daily notes go in `docs/daily-log.md`.
