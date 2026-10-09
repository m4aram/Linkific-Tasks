# FitTrack: project proposal

Oct 9, 2026 · @Maram

FitTrack is a Flutter fitness tracker built by one intern. It covers workout logging, progress charts, goal setting, a BMI calculator and a water intake tracker, with Firebase sign-in and cloud storage.

## Overview

People who exercise at home or at the gym lose track of what they did and cannot tell if they are improving. FitTrack keeps workouts, water intake and goals in one place and shows progress as charts.

- **Goal:** a working Android app that one user can sign in to and use every day to log and review their fitness data.
- **Target user:** adults who train two to five times a week and want a simple personal log.
- **In scope:** the eight features in the table below.
- **Out of scope for version 1:** social features, wearable sync, push notifications, diet and calorie tracking, payments.
- **Team:** one developer (individual project).
- **Duration:** four weeks. This is an assumption; adjust it to the internship schedule.
- **Units:** metric (kg, cm, ml).

## Features

Six features are required for the first working version; the BMI calculator and water tracker come after them.

| # | Feature | What it does | Priority |
| --- | --- | --- | --- |
| 1 | User authentication | Register, log in, log out and reset password with email and password | Must |
| 2 | Workout logging | Add, edit and delete a workout: type, duration, calories (optional), notes, date | Must |
| 3 | Data persistence | Every user's data is saved in Cloud Firestore and stays readable offline through the Firestore cache | Must |
| 4 | Progress charts | Weekly and monthly charts of workout minutes and body weight | Must |
| 5 | Goal setting | Set a weekly workout-minutes goal, a daily water goal and a target weight, and see progress against each | Must |
| 6 | Profile | View and edit name and height; log out | Must |
| 7 | BMI calculator | Enter height and weight, get the BMI value and its category, and save the weight as a new entry | Should |
| 8 | Water intake tracker | Add water in one tap and see today's total against the daily goal | Should |

## User flows

A signed-out user always starts at Login; a signed-in user always starts at Home.

**First use**

1. Open the app and see the Login screen.
2. Tap "Create account".
3. Enter name, email and password, then tap "Register".
4. Land on Home with default goals (150 workout minutes a week, 2,000 ml of water a day).

**Log a workout**

1. Tap the Workouts tab, then the "+" button.
2. Choose the workout type and date, enter the duration, and optionally calories and notes.
3. Tap "Save".
4. The workout appears at the top of the list and the weekly total on Home updates.

**Track water**

1. On Home, tap the water card.
2. Tap "+250 ml" for each glass.
3. The ring fills toward the daily goal.

**Check BMI**

1. On Home, tap "BMI calculator".
2. Enter weight; height is prefilled from the profile.
3. See the BMI value and category, then tap "Save weight" to add it to the weight history.

**Review progress**

1. Tap the Progress tab.
2. Switch between Week and Month.
3. Read the workout-minutes chart and the weight chart.

**Change goals**

1. On Home, tap "Goals".
2. Edit the weekly minutes, daily water or target weight.
3. Tap "Save"; Home and Progress use the new goals at once.

## Screens

The app has 12 screens. Four of them (Home, Workouts, Progress, Profile) are tabs in the bottom navigation bar.

| # | Screen | Purpose | Reached from |
| --- | --- | --- | --- |
| 1 | Splash | Checks the sign-in state and redirects to Login or Home | App start |
| 2 | Login | Sign in with email and password | Splash, log out |
| 3 | Register | Create an account with name, email and password | Login |
| 4 | Forgot password | Send a password reset email | Login |
| 5 | Home | Weekly minutes against the goal, water today, last workout, shortcuts to Goals and BMI | Bottom navigation |
| 6 | Workouts | List of workouts, newest first, with a "+" button | Bottom navigation |
| 7 | Add / edit workout | Form for type, date, duration, calories and notes | Workouts |
| 8 | Progress | Workout-minutes chart and weight chart, by week or month | Bottom navigation |
| 9 | Profile | Name, email, height, log out | Bottom navigation |
| 10 | Goals | Edit weekly minutes, daily water and target weight | Home |
| 11 | BMI calculator | Calculate BMI and save the weight | Home |
| 12 | Water tracker | Add water and see today's total against the goal | Home |

## Backend and API requirements

FitTrack has no custom REST API. The app talks to Firebase through the official Flutter SDKs.

| Need | Firebase service | Operations |
| --- | --- | --- |
| Accounts | Firebase Authentication (email and password) | Sign up, sign in, sign out, send password reset email, listen to auth state |
| User profile and goals | Cloud Firestore | Create on register, read as a live stream, update |
| Workouts | Cloud Firestore | Create, update, delete, stream ordered by date, query by date range |
| Weight entries | Cloud Firestore | Create, stream ordered by date |
| Water logs | Cloud Firestore | Read today's document as a live stream, increment the total |
| Offline use | Firestore offline cache | Reads and writes work offline and sync when the connection returns |

Firebase Storage, Cloud Functions and Cloud Messaging are not used in version 1.

**Security rules.** A user can read and write only documents under their own user ID:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      match /{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

## Database schema

All data lives under one document per user, `users/{uid}`, with three subcollections.

| Document path | Field | Type | Notes |
| --- | --- | --- | --- |
| `users/{uid}` | name | string |  |
|  | email | string |  |
|  | heightCm | number | Optional until the user sets it |
|  | weeklyMinutesGoal | number | Default 150 |
|  | dailyWaterGoalMl | number | Default 2000 |
|  | targetWeightKg | number | Optional |
|  | createdAt | timestamp |  |
| `users/{uid}/workouts/{workoutId}` | type | string | running, walking, cycling, strength, yoga, other |
|  | durationMin | number | Required, greater than 0 |
|  | calories | number | Optional |
|  | notes | string | Optional |
|  | date | timestamp | Day the workout happened |
|  | createdAt | timestamp |  |
| `users/{uid}/weightEntries/{entryId}` | weightKg | number |  |
|  | bmi | number | Calculated from weightKg and heightCm |
|  | date | timestamp |  |
| `users/{uid}/waterLogs/{yyyy-MM-dd}` | totalMl | number | One document per day; the document ID is the date |
|  | updatedAt | timestamp |  |
