# Day 28 Report – Feature Completion

**Project:** Expense Tracker (Flutter + Supabase)
**Date:** October 13, 2026
**Branch:** `feature/day-28-feature-completion`

## Summary

Day 28 turned the Day 27 app into a finished product. All planned features are
complete, every screen has loading, empty and error states, the UI follows one
theme in light and dark mode, the layout adapts to phones, tablets and desktop,
13 bugs were fixed, and the project now has automated tests.

---

## 1. Complete Features

### All planned features done

| Feature | Description |
|---|---|
| Search | Search expenses by title or category from the home screen. |
| Category filter | Chips for each category, with matching icon and color. |
| Period filter | All time, This month, Last month. |
| Sorting | Newest, Oldest, Highest amount, Lowest amount. |
| Monthly summary | "Spent in October 2026" total, all-time total, number of expenses. |
| Category breakdown | Colored bar and percentages for the expenses currently shown. |
| Swipe to delete + Undo | Swipe an expense left to delete it; tap **Undo** to bring it back. |
| Forgot password | "Forgot password?" sends a reset link by email. |
| Theme switch | Light, Dark or System theme from the menu, remembered after restart. |
| Results header | Shows how many expenses match the filters and their total, with "Clear filters". |

### Edge cases handled

| Case | Before | After |
|---|---|---|
| Amount `NaN`, `Infinity`, `1e5` | Accepted by `double.tryParse` and saved | Rejected: "Enter a valid number" |
| Negative amount | Generic error | "Amount must be greater than 0" (minus key is also blocked) |
| More than 2 decimals (`1.234`) | Accepted | "Use at most 2 decimal places" |
| Very large amount | Accepted | Limited to 1,000,000 |
| Decimal comma (`12,50`) | Rejected | Accepted as 12.50 (common on many keyboards) |
| Thousands separator (`1,250.00`) | Rejected | Accepted as 1250.00 |
| Very long title | Unlimited, wrapped onto many lines in the list | Max 50 characters with counter; lists show "…" |
| Category in database not in the app list | Dropdown crashed | Falls back to "Other" |
| Expense date later than today (time zones) | Date picker crashed | Picker date is kept in range |
| Editing without changing anything | Sent an update to the server | "No changes to save", no request |
| Leaving the form with typed data | Data lost silently | "Discard changes?" dialog |
| Sign up with an existing email (Confirm email on) | Showed "Account created" | "An account with this email already exists." |
| Email with spaces or capitals | Could create mismatched accounts | Trimmed and lower-cased |
| Password with leading/trailing space | Accepted | Rejected with a clear message |
| Double-tapping Save / Log in | Could send two requests | Ignored while a request is running |
| Session expires while on a details screen | Old screens stayed open with old data | Returns to Login and clears data |

### Error handling

- `lib/utils/error_messages.dart` turns every error into a message the user can act on:
  - Offline / timeout → "No internet connection. Check your network and try again."
  - Wrong password → "Incorrect email or password."
  - Email not confirmed, too many attempts, permission denied → specific messages.
- All network calls time out after 20 seconds instead of waiting forever.
- Load errors and save errors are now **separate**. Before, a failed save on an empty list replaced the whole home screen with an error page.
- A failed **refresh** keeps the list on screen and shows a snackbar (before, the error was ignored).
- A failed **delete** puts the expense back in the same place and explains why.
- A failed **log out** shows a message instead of an unhandled exception.
- If Supabase cannot start, a "Could not start Expense Tracker" screen appears instead of a blank screen.
- Saving the theme preference can fail without breaking the app.

### Loading states

| Where | Loading state |
|---|---|
| Home, first load | Skeleton placeholders with the same shape as the real list |
| Home, refresh | Pull to refresh |
| Log in, Sign up, Save, Reset password | `LoadingButton` with spinner, fields disabled |
| Error screen | "Try again" hidden while retrying |
| Add button | Shown only after expenses have loaded |

---

## 2. UI/UX Polish

### Consistent styling
- New `lib/theme/app_theme.dart` defines the color scheme, a spacing scale
  (4, 8, 12, 16, 24, 32), corner radius (12 and 20) and the style of cards,
  inputs, buttons, chips, dialogs and snackbars in one place.
- Removed the repeated `border: OutlineInputBorder()` from every text field.
- Each category has its own icon and color (`lib/utils/category_style.dart`),
  used in the list, filters, form and breakdown.
- Shared widgets keep screens consistent: `EmptyState`, `ExpenseTile`,
  `CategoryAvatar`, `LoadingButton`.
- Destructive actions (Delete) use the error color; amounts use tabular figures so digits line up.

### Smooth animations
- Expenses fade and slide in when the list appears (first screenful only).
- The monthly total counts up smoothly when it changes.
- The category icon flies from the list to the details screen (Hero).
- Loading → content → error screens cross-fade; Log in ↔ Home cross-fade.
- Loading buttons fade between text and spinner.
- All animations turn off when the device's "Reduce motion" setting is on.

### Responsive design
- Content is limited to 720 px wide (forms 460 px) and centered on tablets, desktop and web.
- Filter chips scroll sideways on small phones instead of overflowing.
- Summary stats wrap onto a new line when there is not enough space.
- Long titles and emails are cut with "…" instead of overflowing.
- Tested at 320 × 640 (small phone) and 1280 × 800 (tablet / desktop).

### Dark mode
- Full light and dark themes from the same color seed.
- Menu → System / Light / Dark theme; the choice is saved with `shared_preferences`.

### Other UX improvements
- Keyboard: "Next" moves to the next field, "Done" submits; autofill for email and password.
- Show/hide password on sign up too; password rules shown as helper text.
- Friendly dates ("Today", "Yesterday", "Oct 1, 2026").
- Category chips in the form instead of a dropdown (one tap instead of two).
- Clear empty states: "No expenses yet" with an "Add expense" button, and "No matching expenses" with "Clear filters".

---

## 3. Testing

### Automated tests

Run with `flutter test`. Fake services are used, so no Supabase account or internet is needed.

| File | What it tests |
|---|---|
| `test/validators_test.dart` | Every amount, title, email and password rule, including the edge cases above |
| `test/formatters_and_model_test.dart` | Money and date formatting, reading rows from the database, unknown categories |
| `test/expense_provider_test.dart` | Load, failed load, failed refresh, search, filters, sorting, breakdown, add, update, delete, failed delete, undo, logout clear |
| `test/widget_test.dart` | Home summary and list, search + clear filters, empty state, offline error + retry, swipe to delete + undo, small phone in dark mode, tablet size, form validation, adding an expense, discard-changes dialog, unknown category |

The default `widget_test.dart` was the Flutter counter template. It tested a
counter that does not exist in this app, so it failed every time. It has been
replaced with real tests.

### User flows checklist

| # | Flow | Steps | Expected result |
|---|---|---|---|
| 1 | Sign up | Sign up → enter email + password twice | Logged in, or "Check your email" message |
| 2 | Sign up, existing email | Use an email that already has an account | "An account with this email already exists." |
| 3 | Log in | Enter correct email and password | Home screen with skeleton, then expenses |
| 4 | Wrong password | Enter a wrong password | "Incorrect email or password." |
| 5 | Forgot password | Tap "Forgot password?" → Send link | Confirmation snackbar, email received |
| 6 | Add expense | + Add Expense → fill form → Add | "Expense added", appears at the top, totals update |
| 7 | Invalid amount | Type `0`, `1.234`, `2000000` | Matching error under the field |
| 8 | Edit expense | Open expense → Edit → change amount → Save | "Expense updated", new amount shown |
| 9 | Edit, no changes | Open Edit → Save | "No changes to save" |
| 10 | Leave form | Type in form → Back | "Discard changes?" dialog |
| 11 | Delete from details | Details → Delete → confirm | Back to list, "Deleted …" with Undo |
| 12 | Swipe delete + Undo | Swipe left → Undo | Expense comes back |
| 13 | Search / filter / sort | Use search, chips and sort menu | List and results header update |
| 14 | Offline | Turn on airplane mode → pull to refresh | Snackbar: "No internet connection…" and list stays |
| 15 | Theme | Menu → Dark theme → restart app | App stays dark |
| 16 | Log out | Menu → Log out → confirm | Login screen; next user sees no old data |

### Devices checklist

| Device | Size | Light | Dark | Notes |
|---|---|---|---|---|
| Small Android phone | 360 × 640 | ☐ | ☐ | Chips scroll, no overflow |
| Large phone (iPhone / Android) | 430 × 932 | ☐ | ☐ | |
| Tablet | 800 × 1280 | ☐ | ☐ | Content centered at 720 px |
| Web (Chrome) | 1440 × 900 | ☐ | ☐ | |
| Landscape phone | 640 × 360 | ☐ | ☐ | Forms scroll above keyboard |
| Large text (system font size 130%) | – | ☐ | ☐ | No clipped text |

### Bugs fixed

1. Default widget test (counter template) failed on every run.
2. Amount field accepted `NaN`, `Infinity` and `1e5`.
3. Amount field accepted more than 2 decimals and unlimited values.
4. Category dropdown crashed for a category not in the app list.
5. Date picker crashed when the expense date was after today.
6. One shared `error` field: a failed save on an empty list showed the full error screen.
7. Errors during refresh were silently ignored.
8. Log out failure threw an unhandled exception.
9. After a session expired, old screens and the previous user's data stayed open.
10. Duplicate sign-up showed "Account created" when Confirm email was on.
11. Network requests could hang forever (no timeout).
12. Editing without changes still sent an update request.
13. Leaving the form lost typed data without warning.

### Performance

What was improved:
- The filtered and sorted list, totals and breakdown are computed **once per change**, not on every rebuild.
- The list uses `ListView.builder`, so only visible rows are built.
- `context.select` is used where a widget needs one value (theme mode, login state, saving state), so it does not rebuild for unrelated changes.
- `const` constructors everywhere they apply (enforced by lint).
- Entrance animations run only for the first 10 rows.
- The expense query selects only the columns the app uses.

How to measure:
1. `flutter run --profile` on a real device.
2. Open Flutter DevTools → **Performance**, scroll a list of 100+ expenses and switch filters.
3. Target: frames under 16 ms (60 fps), no red (janky) frames.
4. `flutter build apk --analyze-size` to check the app size.

---

## 4. Optimization

### Code optimization
- Derived data cached in `ExpenseProvider` (see Performance).
- Stable sorting so expenses with the same date keep the server order.
- Delete is optimistic: the item disappears immediately and is restored if the server fails.
- Services resolve the Supabase client lazily, so they can be replaced by fakes in tests.

### Image optimization
- The app has no PNG/JPG images. All icons are vector Material icons, which
  Flutter tree-shakes in release builds (only the icons used are included).
- Removed the unused `cupertino_icons` font package, which made the app smaller.

### Remove unused code
- Removed `cupertino_icons` dependency (never used).
- Removed the counter template test.
- Removed repeated per-field styles (moved to the theme).
- Replaced the single `error` getter with `loadError` and `actionError`.

### Clean up comments
- Removed the long template comments from `pubspec.yaml` and `analysis_options.yaml`.
- Kept only comments that explain **why** something is done
  (for example why the date picker range is clamped).
- Enabled stricter lints: `prefer_const_constructors`, `prefer_final_locals`,
  `prefer_single_quotes`, `unawaited_futures`, `avoid_print`, `strict-casts`.

---

## Deliverables

| Deliverable | Status |
|---|---|
| All features complete | ✅ |
| UI polished | ✅ |
| Bugs fixed | ✅ 13 bugs |
| App tested thoroughly | ✅ Automated tests + user flow and device checklists |

## Notes

- The password reset email uses Supabase's default link. To open the app
  directly from the email, add a redirect URL (deep link) in
  **Supabase → Authentication → URL Configuration**.
- `supabase_config.dart` uses the publishable (anon) key, which is safe in the
  app because Row Level Security protects the data.
