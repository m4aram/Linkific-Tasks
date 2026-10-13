# Day 28 – Expense Tracker (Flutter + Supabase)

A Flutter app where each user signs up, logs in, and manages their own expenses.
Data is stored in Supabase and protected with Row Level Security.

Day 28 (Feature Completion) finished the remaining features, polished the UI,
handled edge cases, added tests and cleaned up the code.
Full details: [`DAY_28_REPORT.md`](DAY_28_REPORT.md).

## Day 28 Task Checklist

| Requirement | Where it is done |
|---|---|
| **All planned features done** | Search, category & period filters, sorting, monthly summary with category breakdown, swipe to delete with **Undo**, forgot password, theme switch – `lib/screens/home_screen.dart`, `lib/providers/expense_provider.dart` |
| **Edge cases handled** | Amount validation (`NaN`, `Infinity`, `1e5`, negatives, >2 decimals, max 1,000,000, decimal comma), title length limit, unknown categories, date picker range, duplicate sign-up, editing with no changes, unsaved-changes warning – `lib/utils/validators.dart`, `lib/models/expense.dart`, `lib/screens/expense_form_screen.dart` |
| **Error handling** | Friendly messages for offline / timeout / wrong password / permission errors, 20 s request timeout, failed refresh keeps the list, failed delete puts the item back, startup error screen – `lib/utils/error_messages.dart` |
| **Loading states** | Skeleton list on first load, loading buttons, pull to refresh, disabled fields while saving – `lib/widgets/expense_list_skeleton.dart`, `lib/widgets/loading_button.dart` |
| **Consistent styling** | One theme file with spacing scale, radius, colors and component styles – `lib/theme/app_theme.dart` |
| **Smooth animations** | List entrance, animated total, Hero category icon, animated screen switches; respects “Reduce motion” – `lib/widgets/fade_slide_in.dart`, `lib/widgets/animated_amount.dart` |
| **Responsive design** | Content max width on tablets / desktop / web, scrollable chip rows, wrapping summary – `lib/widgets/responsive_center.dart` |
| **Dark mode** | Light / Dark / System, saved between launches – `lib/providers/theme_provider.dart` |
| **Test all user flows** | 40 unit and widget tests – `test/` |
| **Test on different devices** | Small phone (320 px) + dark mode and tablet (1280 px) widget tests, manual device checklist in the report |
| **Fix bugs** | 13 bugs fixed – see the report |
| **Performance testing** | Filtered list cached once per change, lazy `ListView.builder`, `context.select` to avoid extra rebuilds, profile-mode steps in the report |
| **Code optimization / remove unused code / clean up comments** | Removed `cupertino_icons`, template comments and the broken counter test; enabled stricter lints – `analysis_options.yaml` |
| **Image optimization** | No raster images; all icons are vector Material icons (tree-shaken in release builds) |

## Project Structure

```
expense_tracker/
├── supabase/
│   └── schema.sql                  # Table + Row Level Security policies
├── lib/
│   ├── main.dart                   # App entry, Supabase init, providers, themes
│   ├── config/supabase_config.dart
│   ├── models/expense.dart
│   ├── services/                   # API integration
│   │   ├── auth_service.dart
│   │   └── expense_service.dart
│   ├── providers/                  # State management
│   │   ├── auth_provider.dart
│   │   ├── expense_provider.dart
│   │   └── theme_provider.dart
│   ├── screens/
│   │   ├── auth_gate.dart
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   ├── home_screen.dart
│   │   ├── expense_details_screen.dart
│   │   ├── expense_form_screen.dart
│   │   └── expense_actions.dart    # Delete with undo, delete confirmation
│   ├── theme/app_theme.dart        # Colors, spacing, component styles
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── formatters.dart
│   │   ├── error_messages.dart
│   │   └── category_style.dart
│   └── widgets/
│       ├── loading_button.dart
│       ├── expense_tile.dart
│       ├── expense_list_skeleton.dart
│       ├── summary_card.dart
│       ├── empty_state.dart
│       ├── category_avatar.dart
│       ├── animated_amount.dart
│       ├── fade_slide_in.dart
│       └── responsive_center.dart
└── test/
    ├── fakes.dart                  # Fake services (no Supabase needed)
    ├── validators_test.dart
    ├── formatters_and_model_test.dart
    ├── expense_provider_test.dart
    └── widget_test.dart
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

## How to Test

```bash
flutter analyze     # static checks and lints
flutter test        # unit + widget tests
flutter run --profile   # performance check with DevTools
```

## Tech Stack

- Flutter (Material 3)
- Supabase (`supabase_flutter`)
- Provider
- shared_preferences (saved theme)
