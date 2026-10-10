# Mahami — Task Manager (Flutter + Firebase)

**Training Day 26 deliverable:** authentication, core UI, and backend setup.

Mahami ("my tasks") is a personal task manager. A user creates an account, signs in, and manages a private task list that syncs in real time across devices. Each task can carry notes, a due date, and an image attachment.

| | |
|---|---|
| **Framework** | Flutter (Dart 3, Material 3) |
| **Backend** | Firebase: Authentication, Cloud Firestore, Cloud Storage |
| **Routing** | go_router |
| **Platforms** | Android, iOS (the code is also web-compatible) |
| **Screens** | 6 screens + 1 bottom sheet |
| **Source files** | 24 Dart files, 2 security rule files |

---

## Table of contents

1. [Day 26 requirements checklist](#1-day-26-requirements-checklist)
2. [Getting started](#2-getting-started)
3. [Project structure](#3-project-structure)
4. [Authentication](#4-authentication)
5. [Core UI](#5-core-ui)
6. [Backend](#6-backend)
7. [Screens reference](#7-screens-reference)
8. [Testing checklist](#8-testing-checklist)
9. [Troubleshooting](#9-troubleshooting)
10. [Design decisions and next steps](#10-design-decisions-and-next-steps)

---

## 1. Day 26 requirements checklist

Every item in the Day 26 brief is implemented. The table maps each requirement to the file that fulfils it.

### Learning objectives

| Objective | Status | Summary |
|---|---|---|
| Implement authentication | Done | Email/password auth with Firebase, session persistence, route protection |
| Build core features | Done | Full task CRUD, filtering, statistics, profile photo, theme switching |
| Setup backend | Done | Firestore schema, repositories, real-time listeners, Storage, security rules |
| Create main screens | Done | Splash, Login, Register, Home, Tasks, Profile |

### Tasks

| # | Requirement | Status | Implemented in |
|---|---|---|---|
| **A** | **Implement authentication** | | |
| A1 | Login / register screens | Done | `lib/features/auth/login_screen.dart`, `register_screen.dart` |
| A2 | Firebase / Supabase auth | Done (Firebase) | `lib/services/auth_service.dart` |
| A3 | Splash screen | Done | `lib/features/splash/splash_screen.dart` |
| A4 | Protected routes | Done | `lib/core/router/app_router.dart` |
| **B** | **Build core UI** | | |
| B1 | Navigation structure | Done | `lib/core/router/app_router.dart`, `lib/features/shell/main_shell.dart` |
| B2 | Main screens layout | Done | `lib/features/home/`, `lib/features/tasks/`, `lib/features/profile/` |
| B3 | Reusable components | Done | `lib/core/widgets/` (6 components) |
| B4 | Theme implementation | Done | `lib/core/theme/app_theme.dart` |
| **C** | **Setup backend** | | |
| C1 | Database schema | Done | `lib/models/`, documented in [section 6.1](#61-database-schema) |
| C2 | API endpoints (if needed) | Done (repository layer) | `lib/services/task_repository.dart`, `user_repository.dart` |
| C3 | Real-time listeners | Done | `watchTasks()`, `watchUser()`, `authStateChanges()` |
| C4 | File storage | Done | `lib/services/storage_service.dart`, `storage.rules` |

> **Note on C4:** the upload, download, and delete code and its security rules are complete. Firebase currently requires the Blaze (pay-as-you-go) plan to enable Cloud Storage on a project, so uploads become active once the project is upgraded. All other features work on the free Spark plan.

---

## 2. Getting started

### Prerequisites

- Flutter SDK (stable channel) and Android Studio or VS Code
- Node.js (for the Firebase CLI)
- A Google account

### 2.1 Create the project and add packages

```bash
flutter create mahami
cd mahami

flutter pub add firebase_core firebase_auth cloud_firestore firebase_storage go_router image_picker
flutter pub add flutter_localizations --sdk=flutter
```

Then replace the generated `lib/` folder with the one from this delivery, and copy `firestore.rules` and `storage.rules` to the project root.

### 2.2 Connect the app to Firebase

```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli

firebase login
flutterfire configure
```

`flutterfire configure` registers the app in the Firebase project and generates `lib/firebase_options.dart`, which `main.dart` imports. This generated file is what links the app to the backend.

### 2.3 Enable the Firebase services

In the [Firebase console](https://console.firebase.google.com):

1. **Authentication** → Sign-in method → enable **Email/Password**.
2. **Firestore Database** → Create database → then open the **Rules** tab, paste `firestore.rules`, and publish.
3. **Storage** → Get started → then open the **Rules** tab, paste `storage.rules`, and publish (requires the Blaze plan).

### 2.4 Platform configuration

**Android** — in `android/app/build.gradle.kts`, inside `defaultConfig`:

```kotlin
minSdk = 23
```

**Windows only**, when the project is on a different drive than the Flutter pub cache — add to `android/gradle.properties`:

```properties
kotlin.incremental=false
```

**iOS** — in `ios/Runner/Info.plist`, add `NSPhotoLibraryUsageDescription` with a short reason for accessing photos.

### 2.5 Run

```bash
flutter run
```

---

## 3. Project structure

The project uses a **feature-first** layout with a shared `core` layer and a separate `services` layer.

```
lib/
├── main.dart                       Initializes Firebase and starts the app
├── app.dart                        MaterialApp: theme, locale, router
│
├── core/                           Shared across all features
│   ├── router/
│   │   └── app_router.dart         Routes + auth guard (redirect)
│   ├── theme/
│   │   └── app_theme.dart          Light/dark themes, spacing scale, theme mode
│   ├── utils/
│   │   └── validators.dart         Form validators, date format, snackbar helper
│   └── widgets/                    Reusable components
│       ├── app_button.dart
│       ├── app_text_field.dart
│       ├── state_views.dart        LoadingView, EmptyState
│       ├── stat_card.dart
│       └── task_tile.dart
│
├── models/                         Plain data classes
│   ├── app_user.dart
│   └── task.dart
│
├── services/                       The only layer that talks to Firebase
│   ├── auth_service.dart
│   ├── user_repository.dart
│   ├── task_repository.dart
│   └── storage_service.dart
│
└── features/                       One folder per screen group
    ├── splash/splash_screen.dart
    ├── auth/login_screen.dart
    ├── auth/register_screen.dart
    ├── shell/main_shell.dart       Bottom navigation scaffold
    ├── home/home_screen.dart
    ├── tasks/tasks_screen.dart
    ├── tasks/task_form_sheet.dart
    └── profile/profile_screen.dart

firestore.rules                     Firestore security rules
storage.rules                       Storage security rules
```

**Architecture rule:** screens never call Firebase directly. They call a service or repository, which returns models or streams of models. This keeps UI code free of backend details and means the backend could be swapped (for example to Supabase) by rewriting only `lib/services/`.

```
 Screens (features/)  →  Services & repositories (services/)  →  Firebase
        ↑                              │
        └────── Models (models/) ──────┘
```

---

## 4. Authentication

### 4.1 Login and register screens

Both screens share the same structure: a `Form` with a `GlobalKey<FormState>`, shared `AppTextField` inputs, and an `AppButton` that shows a spinner while the request is in flight.

**Login** (`login_screen.dart`)

- Email and password fields with inline validation
- Show/hide password toggle
- "Forgot password?" sends a reset email through Firebase
- Link to the register screen
- Pressing "done" on the keyboard submits the form

**Register** (`register_screen.dart`)

- Name, email, password, and confirm-password fields
- Confirms that both passwords match before submitting
- On success, creates the Firebase Auth account *and* a profile document in Firestore

**Validation rules** (`core/utils/validators.dart`)

| Field | Rule | Message |
|---|---|---|
| Name | Not empty | "Name is required" |
| Email | Not empty, matches an email pattern | "Enter a valid email address" |
| Password | At least 6 characters | "Password must be at least 6 characters" |
| Confirm password | Equals password | "Passwords do not match" |

### 4.2 Firebase auth service

`AuthService` wraps `FirebaseAuth` so that no screen depends on the Firebase SDK directly.

| Method | What it does |
|---|---|
| `signIn(email, password)` | Signs in with email and password |
| `register(name, email, password)` | Creates the account, writes `users/{uid}`, sets the display name |
| `sendPasswordReset(email)` | Sends a password reset email |
| `signOut()` | Ends the session |
| `messageFor(error)` | Converts Firebase error codes into user-friendly text |

**Error handling.** Raw Firebase codes are never shown to the user. `messageFor` maps them:

| Firebase code | Message shown |
|---|---|
| `invalid-credential`, `wrong-password`, `user-not-found` | Incorrect email or password |
| `email-already-in-use` | This email is already registered |
| `weak-password` | Password is too weak |
| `invalid-email` | Enter a valid email address |
| `user-disabled` | This account has been disabled |
| `too-many-requests` | Too many attempts, please wait and try again |
| `network-request-failed` | Check your internet connection |

The same message is used for a wrong password and an unknown email on purpose, so the login form does not reveal which emails are registered.

### 4.3 Splash screen

The splash screen shows the app logo and a progress indicator while Firebase restores the saved session from disk. It contains **no navigation code**. The router decides where to go next, so the splash cannot get out of sync with the auth state.

A minimum display time of 1.2 seconds prevents the splash from flashing when Firebase answers instantly.

### 4.4 Protected routes

Route protection lives in one place: the `redirect` callback in `app_router.dart`.

`AuthNotifier` subscribes to `FirebaseAuth.authStateChanges()` and is passed to the router as `refreshListenable`. Whenever the user signs in or out, the router re-runs `redirect`, which applies three rules:

| Condition | Result |
|---|---|
| Auth state is not known yet | Go to `/splash` |
| Signed out, requesting a protected route | Go to `/login` |
| Signed in, on `/login`, `/register`, or `/splash` | Go to `/home` |

```
App start ──► /splash ──► session found? ──yes──► /home
                              │
                              no
                              ▼
                           /login ◄──► /register
                              │ sign in / register
                              ▼
                           /home  ◄──► /tasks ◄──► /profile
                              │ sign out
                              ▼
                           /login
```

Consequences of this design:

- There is no `Navigator.push` after login, registration, or sign-out. Changing the auth state is enough.
- A signed-out user cannot reach `/home`, `/tasks`, or `/profile` by any path, including deep links.
- A signed-in user cannot go "back" to the login screen.
- The session persists across app restarts (handled by the Firebase SDK).

---

## 5. Core UI

### 5.1 Navigation structure

| Route | Screen | Access |
|---|---|---|
| `/splash` | SplashScreen | Public (transitional) |
| `/login` | LoginScreen | Signed-out only |
| `/register` | RegisterScreen | Signed-out only |
| `/home` | HomeScreen | Protected, tab 1 |
| `/tasks` | TasksScreen | Protected, tab 2 |
| `/profile` | ProfileScreen | Protected, tab 3 |

The three protected routes are branches of a `StatefulShellRoute.indexedStack`, rendered inside `MainShell` with a Material 3 `NavigationBar`. Each tab keeps its own state (scroll position, selected filter) when the user switches tabs, and tapping the active tab returns it to its first page.

### 5.2 Main screens layout

**Home** — a dashboard: personal greeting, three statistic cards (All, Pending, Done), a progress bar with the completion percentage, and the five most recent pending tasks with a "View all" shortcut.

**Tasks** — the full list with a segmented filter (All / Pending / Done), a floating "New task" button, tap-to-edit, checkbox to complete, and swipe-to-delete with confirmation.

**Profile** — avatar with a change-photo button, name and email, an appearance switch (System / Light / Dark), and sign-out.

**Task form** — a modal bottom sheet used for both creating and editing: title (max 120 characters), optional notes, due-date picker, image attachment with preview.

Every data-driven screen handles four states explicitly: **loading**, **error**, **empty**, and **data**.

### 5.3 Reusable components

All in `lib/core/widgets/`. Screens compose these instead of repeating styling.

| Component | Purpose | Key parameters |
|---|---|---|
| `AppButton` | Primary action button with a loading spinner; disabled while loading | `label`, `onPressed`, `loading`, `icon` |
| `AppTextField` | Text input with label, icon, validation, and optional password toggle | `controller`, `label`, `validator`, `isPassword`, `maxLines`, `maxLength` |
| `LoadingView` | Centered progress indicator | — |
| `EmptyState` | Icon, title, and subtitle for empty lists and errors | `icon`, `title`, `subtitle` |
| `StatCard` | Small card showing one number with a label and icon | `label`, `value`, `icon` |
| `TaskTile` | One task row: checkbox, title, due date, attachment indicator | `task`, `onToggle`, `onTap` |

`TaskTile` is used by both the Home and Tasks screens. It strikes through completed tasks and highlights overdue dates in the error color.

### 5.4 Theme implementation

`AppTheme` builds both themes from a single seed color using `ColorScheme.fromSeed`, which generates a complete, accessible Material 3 palette for light and dark mode.

- **Centralized styling:** input fields, filled buttons, app bars, and snackbars are styled once in `ThemeData`, so widgets need no per-screen styling.
- **Dark mode:** `themeModeNotifier` (a `ValueNotifier<ThemeMode>`) is observed by `MaterialApp`. Changing it from the Profile screen re-themes the whole app instantly.
- **Spacing scale:** `AppSpacing` (`xs` 4, `sm` 8, `md` 16, `lg` 24, `xl` 32) replaces hard-coded padding values.
- **No hard-coded colors:** every screen reads colors from `Theme.of(context).colorScheme`, which is why dark mode works everywhere without extra code.
- **Localization-ready:** `flutter_localizations` is wired in. Changing the locale to `ar` in `app.dart` switches the whole layout to right-to-left.

---

## 6. Backend

### 6.1 Database schema

Cloud Firestore, two collections. Tasks are a **subcollection** of the user who owns them.

```
users (collection)
└── {uid} (document)
    ├── name        string
    ├── email       string
    ├── photoUrl    string | null
    ├── createdAt   timestamp
    │
    └── tasks (subcollection)
        └── {taskId} (document)
            ├── title           string     1 to 120 characters
            ├── note            string
            ├── done            boolean
            ├── dueDate         timestamp | null
            ├── attachmentUrl   string | null    download URL for display
            ├── attachmentPath  string | null    Storage path, used for deletion
            ├── createdAt       timestamp        server time
            └── updatedAt       timestamp        server time
```

**Why a subcollection?**

- Ownership is expressed by the path itself, so the security rule is a single comparison (`request.auth.uid == uid`).
- Queries are naturally scoped to one user, with no `where('userId', ...)` filter.
- Ordering by `createdAt` needs no composite index.

Timestamps use `FieldValue.serverTimestamp()` so ordering is correct even when a device clock is wrong.

### 6.2 API layer

A custom REST API is **not needed** for this app. With Firebase, the client talks to the database directly through the SDK, and access control is enforced by server-side security rules rather than by an intermediate server.

The role of an API is played by the repository classes, which are the only entry points to the data:

**`TaskRepository`**

| Method | Operation | Equivalent REST call |
|---|---|---|
| `watchTasks(uid)` | Live stream of the user's tasks, newest first | `GET /tasks` (subscribed) |
| `addTask(uid, ...)` | Create a task, uploading the attachment if present | `POST /tasks` |
| `updateTask(uid, task, ...)` | Update fields; replace the attachment if a new one is picked | `PATCH /tasks/{id}` |
| `setDone(uid, taskId, done)` | Toggle completion | `PATCH /tasks/{id}` |
| `deleteTask(uid, task)` | Delete the task and its attachment file | `DELETE /tasks/{id}` |

**`UserRepository`**

| Method | Operation |
|---|---|
| `createUser(uid, name, email)` | Create the profile document at registration |
| `watchUser(uid)` | Live stream of the profile |
| `updatePhoto(uid, url)` | Save the avatar URL |

Cloud Functions would only be required for logic that must not run on the device, such as payments, push notifications, or admin operations.

### 6.3 Real-time listeners

Three live streams drive the UI. No screen has a manual "refresh" action because none is needed.

| Listener | Source | Consumed by | Effect |
|---|---|---|---|
| `authStateChanges()` | Firebase Auth | `AuthNotifier` → router | Redirects on sign-in and sign-out |
| `watchTasks(uid)` | `users/{uid}/tasks` snapshots | Home, Tasks | Lists and statistics update instantly |
| `watchUser(uid)` | `users/{uid}` snapshots | Home, Profile | Name and avatar update instantly |

Screens consume these with `StreamBuilder`, which subscribes when the widget appears and cancels automatically when it is disposed, so there are no leaked listeners.

Because Firestore applies local writes immediately (latency compensation), a new or edited task appears in the list before the server confirms it, and the app keeps working with cached data while offline.

### 6.4 File storage

`StorageService` wraps Firebase Cloud Storage.

| Method | What it does |
|---|---|
| `upload(path, bytes, contentType)` | Uploads the bytes and returns the download URL |
| `delete(path)` | Deletes a file; a missing file is treated as success |

**Storage layout**

```
users/{uid}/avatar.jpg                          Profile photo
users/{uid}/tasks/{taskId}/{timestamp}.jpg      Task attachment
```

**Upload flow**

1. The user picks an image with `image_picker` (resized and compressed on the device to save bandwidth and storage).
2. The bytes are uploaded with `putData`, which works on mobile and web.
3. `getDownloadURL()` returns a URL.
4. The URL and the storage path are saved in Firestore.

**Cleanup.** Deleting a task also deletes its attachment. Replacing an attachment deletes the old file, but only after the Firestore update has succeeded, so a failed update never leaves a task pointing at a deleted file.

### 6.5 Security rules

Security is enforced on the server, not in the app. Even a modified client cannot bypass these rules.

**Firestore** (`firestore.rules`)

- A user can read and write only `users/{their own uid}` and its subcollections.
- Task writes are validated: `title` must be a string of 1 to 120 characters, and `done` must be a boolean.
- Everything else is denied by default.

**Storage** (`storage.rules`)

- A user can read, write, and delete only files under `users/{their own uid}/`.
- Uploads must be images and smaller than 5 MB.

---

## 7. Screens reference

| Screen | What the user sees | Interactions |
|---|---|---|
| **Splash** | Primary-color background, logo, app name, spinner | None; redirects automatically |
| **Login** | Logo, "Welcome back", email and password fields, "Forgot password?", "Sign in", link to register | Validation under each field; errors in a snackbar; success opens Home |
| **Register** | "Create a new account", four fields, "Create account", link to login | Password match check; success opens Home |
| **Home** | Greeting, three stat cards, progress bar, up to five pending tasks | Check a task to complete it; tap a task to edit; "View all" opens Tasks |
| **Tasks** | Filter (All / Pending / Done), task list, "New task" button | Tap to edit; swipe to delete with confirmation; checkbox to complete |
| **Task form** | Title, notes, due date, image attachment, preview | Add or save; closes on success |
| **Profile** | Avatar, name, email, appearance switch, "Sign out" | Change photo; switch theme; sign out |

The bottom navigation bar (Home, Tasks, Profile) is visible only on the three protected screens.

---

## 8. Testing checklist

Manual acceptance tests covering every Day 26 requirement.

| # | Test | Expected result | Covers |
|---|---|---|---|
| 1 | Launch the app while signed out | Splash, then Login | A3, A4 |
| 2 | Submit the login form empty | Error text under each field | A1 |
| 3 | Sign in with a wrong password | "Incorrect email or password" | A2 |
| 4 | Register a new account | Opens Home with the user's name; a document appears in `users` | A1, A2, C1 |
| 5 | Close and reopen the app | Splash, then Home directly | A3, A4 |
| 6 | Sign out | Returns to Login; back button does not return to Home | A4 |
| 7 | Switch between the three tabs | Each tab keeps its scroll position and filter | B1 |
| 8 | Add a task with a due date | Appears immediately in Tasks and Home | B2, C2, C3 |
| 9 | Complete a task | Statistics and progress bar on Home change instantly | C3 |
| 10 | Edit a document in the Firebase console | The app updates without restarting | C3 |
| 11 | Swipe a task and confirm | The task is removed | B2, C2 |
| 12 | Switch theme to Dark | The whole app re-themes instantly | B4 |
| 13 | Add a task with an image | File appears in Storage; preview shows when editing | C4 |
| 14 | Change the profile photo | Avatar updates on Profile | C4 |
| 15 | Sign in with a second account | The first account's tasks are not visible | C1, security rules |

Tests 13 and 14 require Cloud Storage to be enabled on the Firebase project.

---

## 9. Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| `firebase_options.dart` not found | The app is not linked to Firebase yet | Run `flutterfire configure` |
| Gradle build fails mentioning `minSdkVersion` | Firebase needs Android API 23 or higher | Set `minSdk = 23` in `android/app/build.gradle.kts` |
| Gradle error `this and base files have different roots` | Project and pub cache are on different Windows drives | Add `kotlin.incremental=false` to `android/gradle.properties` |
| "Could not complete the operation (unknown)" on register | Email/Password sign-in is not enabled, or the emulator has no internet | Enable the provider in the console; check the emulator's connection; read the `Auth error:` line in the Run console |
| "Could not load data" on Home | Firestore is not created or the rules are not published | Create the database and publish `firestore.rules` |
| "Could not upload the photo" | Cloud Storage is not enabled on the project | Enable Storage (Blaze plan) and publish `storage.rules` |

Full error details are printed to the Run console with the prefix `Auth error:`.

---

## 10. Design decisions and next steps

### Decisions

| Decision | Reason |
|---|---|
| Firebase over Supabase | Listed first in the brief; mature Flutter SDK; built-in offline cache and real-time streams |
| `go_router` with a single `redirect` | One place decides access, so screens cannot bypass the auth guard |
| `StreamBuilder` + `ValueNotifier` for state | Enough for this scope and keeps the code readable without an extra state-management dependency |
| Tasks as a subcollection | Simplest possible security rule and no composite indexes |
| Repository layer | Screens stay independent of Firebase and are easier to test and change |
| Bytes-based upload (`putData`) | Works on mobile and web without `dart:io` |

### Possible next steps

- Persist the selected theme with `shared_preferences`
- Add Google sign-in and email verification
- Native launch screen with `flutter_native_splash`
- Local notifications for due dates
- Migrate state management to Riverpod or Bloc as the app grows
- Unit tests for validators and repositories, widget tests for the auth flow
- Arabic translation using `.arb` files (the RTL layout is already supported)
