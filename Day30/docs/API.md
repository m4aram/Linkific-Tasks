# API Documentation

Expense Tracker has **no custom server**. It talks directly to Supabase:

- **Supabase Auth** (`/auth/v1/...`) for accounts
- **PostgREST** (`/rest/v1/...`), the REST API Supabase generates for the `expenses` table

The app never builds these HTTP requests by hand. It calls the
`supabase_flutter` client inside two service classes, and the client sends the
requests below. They are documented here so the backend can be understood,
tested with Postman / curl, or replaced later.

**Base URL:** `https://<project-ref>.supabase.co` (set in `lib/config/supabase_config.dart`)

Contents:
1. [Authentication headers](#1-authentication-headers)
2. [Database schema](#2-database-schema)
3. [Auth endpoints](#3-auth-endpoints)
4. [Expense endpoints](#4-expense-endpoints)
5. [Errors](#5-errors)
6. [Dart API: services](#6-dart-api-services)
7. [Dart API: providers (state)](#7-dart-api-providers-state)
8. [Dart API: model and utilities](#8-dart-api-model-and-utilities)

---

## 1. Authentication headers

Every request sends:

| Header | Value |
|---|---|
| `apikey` | The project's publishable (anon) key |
| `Authorization` | `Bearer <access_token>` of the logged-in user (after login) |
| `Content-Type` | `application/json` |

The access token is a JWT returned by login. `supabase_flutter` stores it,
refreshes it automatically and adds it to every request. Row Level Security
reads the user id from this token (`auth.uid()`).

---

## 2. Database schema

Table **`public.expenses`** (created by `supabase/schema.sql`; that file is
the source of truth if anything below differs):

| Column | Type | Rules | Set by |
|---|---|---|---|
| `id` | `uuid` | primary key | database (`gen_random_uuid()`) |
| `user_id` | `uuid` | references `auth.users`, not null | database (`auth.uid()`) |
| `title` | `text` | 1–50 characters | app |
| `amount` | `numeric` | > 0 and ≤ 1,000,000, 2 decimals | app |
| `category` | `text` | `Food`, `Transport`, `Shopping`, `Bills`, `Health`, `Other` | app |
| `date` | `date` | `YYYY-MM-DD` | app |
| `created_at` | `timestamptz` | used as a tie-breaker when sorting | database (`now()`) |

**Row Level Security** is enabled. The select, insert, update and delete
policies all require `auth.uid() = user_id`, so each user only ever sees and
changes their own rows. A logged-out request returns an empty list.

---

## 3. Auth endpoints

### 3.1 Sign up
`AuthService.signUp(email, password)` → `POST /auth/v1/signup`

```json
{ "email": "maram@example.com", "password": "secret123" }
```

**200 OK**

```json
{
  "access_token": "eyJhbGciOi...",      // only when "Confirm email" is OFF
  "token_type": "bearer",
  "expires_in": 3600,
  "refresh_token": "v1.Mj...",
  "user": { "id": "7c1e...", "email": "maram@example.com", "identities": [ { ... } ] }
}
```

- With "Confirm email" **on**, there is no session, and the user must click the email link first.
- With "Confirm email" **on**, an email that is **already registered** returns
  a user with `identities: []` instead of an error. `AuthProvider.signUp`
  detects this and shows *"An account with this email already exists."*

### 3.2 Log in
`AuthService.signIn(email, password)` → `POST /auth/v1/token?grant_type=password`

```json
{ "email": "maram@example.com", "password": "secret123" }
```

**200 OK**: same shape as sign up, always with `access_token`.
**400**: `{"error_code": "invalid_credentials", "msg": "Invalid login credentials"}`

### 3.3 Reset password
`AuthService.sendPasswordReset(email)` → `POST /auth/v1/recover`

```json
{ "email": "maram@example.com" }
```

**200 OK** with an empty body. For privacy it succeeds even if the email is not
registered, so the app says *"If an account exists for …, a reset link is on its way."*

### 3.4 Log out
`AuthService.signOut()` → `POST /auth/v1/logout` → **204 No Content**.
The local session is removed and `AuthGate` shows the login screen.

### 3.5 Session changes
`AuthService.authStateChanges` is a stream (`onAuthStateChange`) of
`signedIn`, `signedOut`, `tokenRefreshed`, … events. `AuthProvider` only
rebuilds the UI when the **user** changes, not on every token refresh.

---

## 4. Expense endpoints

### 4.1 List expenses
`ExpenseService.fetchExpenses()`

```http
GET /rest/v1/expenses?select=id,title,amount,category,date&order=date.desc,created_at.desc
```

**200 OK**

```json
[
  { "id": "b3f0c2a4-...", "title": "Lunch with team", "amount": 42.5, "category": "Food", "date": "2026-10-13" },
  { "id": "9d1e77aa-...", "title": "Metro card",      "amount": 3,    "category": "Transport", "date": "2026-10-02" }
]
```

### 4.2 Add expense
`ExpenseService.addExpense(expense)`

```http
POST /rest/v1/expenses?select=*
Prefer: return=representation
```
```json
{ "title": "Lunch with team", "amount": 42.5, "category": "Food", "date": "2026-10-13" }
```

**201 Created**: the new row (one object, because of `.single()`), including
the `id`, `user_id` and `created_at` set by the database.

### 4.3 Edit expense
`ExpenseService.updateExpense(expense)`

```http
PATCH /rest/v1/expenses?id=eq.b3f0c2a4-...&select=*
Prefer: return=representation
```
```json
{ "title": "Team lunch", "amount": 45, "category": "Food", "date": "2026-10-13" }
```

**200 OK**: the updated row. If the id does not exist or belongs to another
user, no row matches and `.single()` throws a `PostgrestException`.

### 4.4 Delete expense
`ExpenseService.deleteExpense(id)`

```http
DELETE /rest/v1/expenses?id=eq.b3f0c2a4-...
```

**204 No Content**. "Undo" calls **Add expense** again with the same data,
so the restored expense gets a new `id`.

### Try it with curl

```bash
URL=https://<project-ref>.supabase.co
KEY=<publishable-key>

# 1) log in and copy access_token from the response
curl -s "$URL/auth/v1/token?grant_type=password" \
  -H "apikey: $KEY" -H "Content-Type: application/json" \
  -d '{"email":"maram@example.com","password":"secret123"}'

TOKEN=<access_token>

# 2) list my expenses
curl -s "$URL/rest/v1/expenses?select=id,title,amount,category,date&order=date.desc" \
  -H "apikey: $KEY" -H "Authorization: Bearer $TOKEN"
```

---

## 5. Errors

All errors are turned into user-friendly text by `friendlyError()` in
`lib/utils/error_messages.dart`:

| Cause | Detected by | Message shown |
|---|---|---|
| No network, DNS or TLS failure | `SocketException`, `ClientException`, `HandshakeException`, `AuthRetryableFetchException` | No internet connection. Check your network and try again. |
| Request took longer than 20 s | `TimeoutException` (added by the providers) | same as above |
| Wrong email or password | `AuthException` "invalid login credentials" | Incorrect email or password. |
| Email not confirmed | `AuthException` "email not confirmed" | Please confirm your email before logging in. |
| Duplicate sign-up | `AuthException` "already registered" | An account with this email already exists. |
| Too many attempts | `AuthException` status `429` / "rate limit" | Too many attempts. Please wait a minute and try again. |
| RLS blocked the action | `PostgrestException` code `42501` | You do not have permission to change this expense. |
| Any other database error | `PostgrestException` | The server could not complete the request. Please try again. |
| Anything else | — | Something went wrong. Please try again. |

---

## 6. Dart API: services

`lib/services/`. Thin wrappers, one method per request. Both accept an
optional `SupabaseClient` in the constructor so tests can inject a fake.

### `AuthService`

| Member | Returns | Description |
|---|---|---|
| `currentUser` | `User?` | Logged-in user, or null |
| `authStateChanges` | `Stream<AuthState>` | Login / logout / token refresh events |
| `signUp({email, password})` | `Future<AuthResponse>` | Create account |
| `signIn({email, password})` | `Future<AuthResponse>` | Log in |
| `sendPasswordReset(email)` | `Future<void>` | Email a reset link |
| `signOut()` | `Future<void>` | Log out |

### `ExpenseService`

| Method | Returns | Description |
|---|---|---|
| `fetchExpenses()` | `Future<List<Expense>>` | All of the user's expenses, newest first |
| `addExpense(expense)` | `Future<Expense>` | Insert and return the saved row |
| `updateExpense(expense)` | `Future<Expense>` | Update by `expense.id` and return the saved row |
| `deleteExpense(id)` | `Future<void>` | Delete by id |

Services **throw** on failure. Catching errors is the providers' job.

---

## 7. Dart API: providers (state)

`lib/providers/`. All are `ChangeNotifier`s registered in `main.dart`.
Action methods **never throw**. They return `true` / `false` and put a
friendly message in an error field.

### `AuthProvider`

| Member | Type | Description |
|---|---|---|
| `user`, `isLoggedIn` | `User?`, `bool` | Current user |
| `isLoading` | `bool` | True while a request runs (buttons show a spinner) |
| `error` | `String?` | Friendly message from the last failed action |
| `signIn(email, password)` | `Future<bool>` | Email is trimmed and lower-cased |
| `signUp(email, password)` | `Future<bool>` | Detects duplicate accounts |
| `sendPasswordReset(email)` | `Future<bool>` | |
| `signOut()` | `Future<bool>` | |

### `ExpenseProvider`

| Member | Type | Description |
|---|---|---|
| `expenses` | `List<Expense>` | Everything loaded (read-only) |
| `visibleExpenses` | `List<Expense>` | After search, filters and sort |
| `isLoading`, `hasLoaded`, `isSaving` | `bool` | Loading states |
| `loadError`, `actionError` | `String?` | Friendly error messages |
| `total`, `thisMonthTotal`, `visibleTotal` | `double` | Totals |
| `categoryTotals` | `List<CategoryTotal>` | Breakdown of the visible list, largest first |
| `query`, `category`, `period`, `sort`, `hasActiveFilters` | | Current filters |
| `loadExpenses()` | `Future<bool>` | A failed refresh keeps the current list |
| `addExpense(e)`, `updateExpense(e)` | `Future<bool>` | |
| `deleteExpense(id)` | `Future<bool>` | Optimistic: removed at once, put back if the server fails |
| `restoreExpense(e)` | `Future<bool>` | Used by "Undo" |
| `setQuery`, `setCategory`, `setPeriod`, `setSort`, `clearFilters()` | `void` | |
| `findById(id)` | `Expense?` | |
| `clear()` | `void` | Called on logout |

Enums: `ExpensePeriod { all, thisMonth, lastMonth }`,
`ExpenseSort { newest, oldest, highest, lowest }`. Each has a `label`.

### `ThemeProvider`

| Member | Description |
|---|---|
| `mode` | `ThemeMode.system` / `light` / `dark` |
| `setMode(mode)` | Changes the theme and saves it in `SharedPreferences` (key `theme_mode`) |

---

## 8. Dart API: model and utilities

### `Expense` (`lib/models/expense.dart`)

| Member | Description |
|---|---|
| `id, title, amount, category, date` | Fields |
| `Expense.categories` | The 6 allowed categories |
| `Expense.fromMap(map)` | From a database row. An unknown category becomes `Other`, and a text amount is parsed. |
| `toMap()` | `{title, amount, category, date}` for insert / update |
| `copyWith(...)` | Copy with changes |
| `hasSameContentAs(other)` | Used to skip saving when nothing changed |

### Utilities (`lib/utils/`)

| Function | Example |
|---|---|
| `Validators.email / password / confirmPassword / title / amount` | Return an error string or `null` |
| `Validators.parseAmount('1,250.50')` | `1250.5` (`null` for `NaN`, `1e5`, `-3`) |
| `formatAmount(1234567.8)` | `$1,234,567.80` |
| `formatDate(date)` | `2026-10-13` |
| `formatFriendlyDate(date)` | `Today`, `Yesterday`, `Oct 13, 2026` |
| `formatMonth(date)` | `October 2026` |
| `friendlyError(error)` | See [Errors](#5-errors) |
| `CategoryStyle.of('Food')` | Icon + color for a category |
