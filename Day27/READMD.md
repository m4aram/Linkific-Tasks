   # Day 27 – Expense Tracker App

A Flutter app where each user signs up, logs in, and manages their own expenses.
Data is stored in Supabase and protected with Row Level Security.

## Task Checklist

| Requirement | Where it is done |
|---|---|
| **CRUD operations** | Add, view, edit and delete expenses – `lib/services/expense_service.dart` |
| **State management** | Provider (`ChangeNotifier`) – `lib/providers/` |
| **API integration** | Supabase client (Auth + Database API) – `lib/services/` |
| **Data persistence** | Supabase Postgres table `expenses` – `supabase/schema.sql` |
| **Forms with validation** | Login, Sign up, Add/Edit expense – `lib/utils/validators.dart` |
| **Button actions** | Log in, Sign up, Add, Save, Edit, Delete, Log out, Retry |
| **Navigation flows** | Login ↔ Sign up, Home → Details → Edit, Home → Add, auto switch on login/logout (`AuthGate`) |
| **Loading states** | Loading buttons, list loading spinner, pull to refresh, delete spinner |
| **Code reviews** | Every feature merged through a reviewed Pull Request |
| **Merge branches** | One branch per feature, merged into `main` |
| **Resolve conflicts** | Conflict resolved while merging into `main` |
| **Integration** | All branches merged and tested together on `main` |


## Project Structure

```
expense_tracker/
├── supabase/
│   └── schema.sql              # Table + Row Level Security policies
└── lib/
    ├── main.dart               # App entry, Supabase init, providers
    ├── config/
    │   └── supabase_config.dart
    ├── models/
    │   └── expense.dart
    ├── services/               # API integration
    │   ├── auth_service.dart
    │   └── expense_service.dart
    ├── providers/              # State management
    │   ├── auth_provider.dart
    │   └── expense_provider.dart
    ├── screens/
    │   ├── auth_gate.dart
    │   ├── login_screen.dart
    │   ├── signup_screen.dart
    │   ├── home_screen.dart
    │   ├── expense_details_screen.dart
    │   └── expense_form_screen.dart
    ├── utils/
    │   ├── validators.dart
    │   └── formatters.dart
    └── widgets/
        └── loading_button.dart
```

## How to Run

1. Create a project on [supabase.com](https://supabase.com).
2. Open **SQL Editor**, paste `supabase/schema.sql`, and click **Run**.
3. (Optional for testing) **Authentication → Sign In / Providers → Email**: turn off **Confirm email**.
4. Copy **Project URL** and **anon key** from **Project Settings → API** into `lib/config/supabase_config.dart`.
5. Run:
   ```bash
   cd expense_tracker
   flutter pub get
   flutter run
   ```

## Tech Stack

- Flutter
- Supabase (`supabase_flutter`)
- Provider

