# Supabase Flutter App

A Flutter application built to demonstrate the main **Supabase features** required for the learning task, including authentication, database operations, Row Level Security (RLS), and real-time functionality.

---

## 📚 Learning Objectives

This project demonstrates how to:

* Set up Supabase in a Flutter application.
* Implement Supabase Authentication.
* Use Supabase PostgreSQL Database.
* Implement real-time features using Supabase Realtime.
* Perform CRUD operations.
* Handle authentication sessions.
* Protect application pages using an AuthGate.

---

# ⚙️ Supabase Setup

## 1. Create a Supabase Project

1. Create an account at [Supabase](https://supabase.com/).
2. Create a new project.
3. Open **Project Settings**.
4. Copy the **Project URL**.
5. Copy the **Publishable/Anon Key**.

> ⚠️ Use only the Publishable/Anon key inside the Flutter application.
> Never expose the **Service Role Key** in a client application.

---

## 2. Install Supabase Flutter Package

Run the following commands:

```bash
flutter pub add supabase_flutter
```

Then:

```bash
flutter pub get
```

---

## 3. Initialize Supabase

Initialize Supabase in `main.dart`:

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_PUBLISHABLE_KEY',
);
```

You can then access the Supabase client using:

```dart
final supabase = Supabase.instance.client;
```

---

# 🔐 Authentication

The application includes the following authentication features:

* Email and password sign up
* Email and password sign in
* Magic Link authentication
* Google OAuth
* Sign out
* Session handling
* Authentication state handling
* AuthGate for protected pages

---

## ✏️ Sign Up

Users can create an account using their email and password.

```dart
await supabase.auth.signUp(
  email: email,
  password: password,
);
```

---

## 🔑 Sign In

Users can sign in using their email and password.

```dart
await supabase.auth.signInWithPassword(
  email: email,
  password: password,
);
```

---

## 🔗 Magic Link

The application supports passwordless authentication using a Magic Link.

```dart
await supabase.auth.signInWithOtp(
  email: email,
  emailRedirectTo: 'io.supabase.flutter://login-callback/',
);
```

---

## 🌐 Google OAuth

Google authentication is implemented using Supabase OAuth.

```dart
await supabase.auth.signInWithOAuth(
  OAuthProvider.google,
  redirectTo: 'io.supabase.flutter://login-callback/',
);
```

> **Note:** Magic Link and Google OAuth require the correct Redirect URLs and authentication providers to be configured in the Supabase Dashboard.

---

## 🚪 Sign Out

Users can sign out using:

```dart
await supabase.auth.signOut();
```

---

# 🗄️ Database

The project uses **Supabase PostgreSQL** as its database.

The main tables are:

* `profiles`
* `notes`
* `messages`

---

## ➕ Insert Data

Example of inserting a new note:

```dart
await supabase.from('notes').insert({
  'title': 'New Note',
});
```

---

## 📖 Select Data

Retrieve notes from the database:

```dart
final data = await supabase
    .from('notes')
    .select();
```

---

## ✏️ Update Data

Update an existing note:

```dart
await supabase
    .from('notes')
    .update({
      'title': 'Updated Note',
    })
    .eq('id', noteId);
```

---

## 🗑️ Delete Data

Delete a note:

```dart
await supabase
    .from('notes')
    .delete()
    .eq('id', noteId);
```

---

# 🔒 Row Level Security (RLS)

**Row Level Security (RLS)** is enabled for the application's database tables.

RLS policies control which authenticated users can:

* Read records
* Insert records
* Update records
* Delete records

### Example Policy

The following policy allows authenticated users to read messages:

```sql
create policy "Users can view messages"
on public.messages
for select
to authenticated
using (true);
```

Insert policies can also verify that the authenticated user's ID matches the user or sender ID stored in the database record.

---

# ⚡ Real-Time Features

Supabase Realtime is enabled for the application's real-time tables.

The chat feature uses **Supabase Realtime** to listen for changes in the `messages` table.

### Realtime Example

```dart
final channel = supabase
    .channel('messages-realtime')
    .onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'messages',
      callback: (payload) {
        print(payload);
      },
    )
    .subscribe();
```

When the channel is no longer needed, it should be removed:

```dart
await supabase.removeChannel(channel);
```

---

# 💬 Real-Time Chat

The chat feature demonstrates how Supabase Realtime can be used to create a real-time messaging system.

The application listens for database changes in the `messages` table and updates the interface when new messages or changes are received.

---

# 🔄 CRUD Operations

The project demonstrates the four main database operations:

| Operation  | Description             |
| ---------- | ----------------------- |
| **Create** | Insert new records      |
| **Read**   | Retrieve records        |
| **Update** | Modify existing records |
| **Delete** | Remove records          |

These operations are implemented using Supabase PostgreSQL tables.

---

# 🏗️ Application Structure

The project follows a feature-based structure:

```text
lib/
│
├── main.dart
├── home_page.dart
│
├── chat/
│   ├── chat_page.dart
│   └── chat_service.dart
│
├── features/
│   │
│   ├── auth/
│   │   ├── auth_service.dart
│   │   ├── login_page.dart
│   │   └── signup_page.dart
│   │
│   ├── notes/
│   │   ├── notes_page.dart
│   │   └── notes_service.dart
│   │
│   └── profile/
│       ├── profile_page.dart
│       └── profile_service.dart
│
└── README.md
```

---

# 🔁 Application Flow

The application follows this authentication flow:

```text
App Start
    │
    ▼
Supabase Initialization
    │
    ▼
AuthGate
    │
    ▼
Check Current Session
    │
    ├─────────────────────┐
    │                     │
    ▼                     ▼
Logged In             Logged Out
    │                     │
    ▼                     ▼
Home Page             Login Page
    │
    ├── Profile
    │
    ├── Notes
    │
    ├── Chat
    │
    └── Sign Out
```

---

# 🔐 AuthGate

The `AuthGate` checks whether the user currently has an active Supabase session.

### If the user is logged in:

```text
Logged In
    ↓
Home Page
```

### If the user is not logged in:

```text
Logged Out
    ↓
Login Page
```

This prevents unauthorized users from accessing protected application pages.

---

# 📝 Notes Feature

The Notes feature demonstrates database CRUD operations.

Users can:

* Create notes
* View notes
* Update notes
* Delete notes

The data is stored in the Supabase `notes` table.

---

# 👤 Profile Feature

The Profile feature is connected to the `profiles` table.

The profile section can be used to display and manage user information associated with the authenticated Supabase account.

---

# 💬 Chat Feature

The Chat feature uses the `messages` table and Supabase Realtime.

It demonstrates:

* Sending messages
* Reading messages
* Listening for new messages
* Receiving database updates in real time

---

# 🛡️ Security

The application follows Supabase security practices:

* Authentication is handled by Supabase Auth.
* Database access is protected using RLS.
* The Publishable/Anon Key is used in the Flutter client.
* The Service Role Key must never be included in the Flutter application.
* Authenticated users are controlled through Supabase sessions and RLS policies.

---

# 🛠️ Technologies Used

| Technology             | Purpose                      |
| ---------------------- | ---------------------------- |
| **Flutter**            | Mobile application framework |
| **Dart**               | Programming language         |
| **Supabase**           | Backend platform             |
| **Supabase Auth**      | Authentication               |
| **PostgreSQL**         | Database                     |
| **Supabase Realtime**  | Real-time communication      |
| **Row Level Security** | Database security            |

---

# 📦 Main Supabase Features Used

The project demonstrates:

* ✅ Supabase Initialization
* ✅ Email Authentication
* ✅ Password Authentication
* ✅ Magic Link
* ✅ Google OAuth
* ✅ Session Management
* ✅ AuthGate
* ✅ PostgreSQL Database
* ✅ CRUD Operations
* ✅ Row Level Security
* ✅ Supabase Realtime
* ✅ Real-Time Chat

---

# 🚀 Getting Started

## 1. Clone or Open the Project

Open the project in **Android Studio** or **VS Code**.

## 2. Install Dependencies

```bash
flutter pub get
```

## 3. Configure Supabase

Add your Supabase project URL and Publishable/Anon Key to the Supabase initialization.

## 4. Configure Authentication

Enable the required authentication providers from the Supabase Dashboard:

* Email
* Google OAuth

Configure the required Redirect URLs for Magic Link and Google OAuth.

## 5. Run the Application

```bash
flutter run
```

---

# 🌐 Supabase

This project uses [Supabase](https://supabase.com/) as its backend platform.

Supabase provides:

* PostgreSQL Database
* Authentication
* Realtime
* Storage
* APIs
* Edge Functions
* Vector capabilities

---

# 📌 Project Summary

This project demonstrates how to build a Flutter application integrated with Supabase as a backend service.

The application combines **authentication, database CRUD operations, Row Level Security, session management, and real-time communication** in one project.

It provides a practical example of using Supabase services in a Flutter mobile application.

```

هذا الشكل أنسب كـ **README لمشروع GitHub** لأنه مرتب من: **Setup → Authentication → Database → RLS → Realtime → Structure → Flow → Features → Technologies → Run**.
```
