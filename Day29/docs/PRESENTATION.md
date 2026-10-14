# Presentation Kit

Everything needed to present Expense Tracker: timing, a word-for-word script,
a backup plan, likely questions and the video demo plan.

**Presenter:** Maram Sharaf
**Total time:** about 11 minutes + 3–5 minutes Q&A.
**Slides:** the Expense Tracker deck (12 slides, speaker notes on every slide).

---

## 1. Timing plan

| # | Slide | Time |
|---|---|---|
| 1 | Title | 0:20 |
| 2 | Agenda | 0:15 |
| 3 | Problem statement | 0:50 |
| 4 | Proposed solution | 1:00 |
| 5 | Application screens | 0:40 |
| 6 | Live demonstration | 4:00 |
| 7 | System architecture | 1:00 |
| 8 | Technology stack | 0:40 |
| 9 | Quality assurance | 0:50 |
| 10 | Release and deployment | 0:50 |
| 11 | Lessons learned and future work | 0:40 |
| 12 | Thank you / Q&A | 0:20 |
| | **Total** | **≈ 11:25** |

Practise the full run at least twice with a timer. If you run long, shorten the live demo, not the opening.

---

## 2. Before you present: setup checklist

- [ ] Release APK installed on the demo phone (or emulator open), phone fully charged
- [ ] Screen mirroring tested (scrcpy / Android Studio "Running Devices" / projector cable)
- [ ] **Do Not Disturb** on, notifications off
- [ ] Internet working on the phone, with a hotspot as backup
- [ ] Logged **out**, so the demo starts on the login screen
- [ ] Demo account ready: `demo@expensetracker.app` / password written on paper
- [ ] Demo account already has **6–8 expenses** across categories and two months (list below)
- [ ] Video demo file open in another window as a backup
- [ ] Slides open in presenter mode, font size readable from the back

**Seed data for the demo account** (add the day before):

| Title | Amount | Category | Date |
|---|---|---|---|
| Groceries | 54.20 | Food | this month |
| Coffee with friends | 8.50 | Food | this month |
| Metro card | 25.00 | Transport | this month |
| Electricity bill | 61.75 | Bills | this month |
| Pharmacy | 14.30 | Health | this month |
| New headphones | 89.99 | Shopping | last month |
| Taxi to airport | 32.00 | Transport | last month |

---

## 3. Script

The full text for each slide is also in the slide's speaker notes.

### Slide 1 – Title (0:20)
> "Good morning, everyone. Thank you for joining me. Today I am presenting my
> final project, Expense Tracker: a secure mobile application that helps users
> record their daily expenses and understand where their money goes.
> My name is Maram Sharaf."

### Slide 2 – Agenda (0:15)
> "The presentation is organised in six parts: the problem and objectives, the
> solution and its features, the application screens with a live
> demonstration, the technical architecture, quality assurance and release,
> and finally my conclusions and your questions."

### Slide 3 – Problem statement (0:50)
> "Most people know their income, but not exactly where it is spent. Small
> daily purchases such as coffee, transport and deliveries accumulate without
> being noticed. Notebooks and spreadsheets require effort, so people usually
> stop using them after a short time. In addition, financial data is personal
> and must be protected. My objective was therefore to build a fast, secure
> and easy-to-use mobile application for recording and analysing personal
> expenses."

### Slide 4 – Proposed solution (1:00)
> "Expense Tracker offers six core capabilities: secure accounts with
> sign-up, login and password reset; complete expense management in six
> categories; a monthly summary with a category breakdown; search, filters and
> sorting; safe deletion with Undo; and light and dark themes."

### Slide 5 – Application screens (0:40)
> "These are the main screens: login, account creation, password reset, the
> home screen with the monthly summary and filters, the form for adding an
> expense, and the menu for theme and logout. I will now demonstrate them live."

### Slide 6 – Live demonstration (4:00)

Switch to the phone or emulator screen. Speak while you tap, and keep moving.

| Time | Do | Say |
|---|---|---|
| 0:00 | Login screen | "This is the login screen. New users can sign up here, and 'Forgot password' sends a reset link by email." |
| 0:15 | Wrong password → Log In | "If the password is wrong, the user receives a clear message rather than a technical error." |
| 0:30 | Correct password → Log In | "With the correct password, a loading placeholder appears while the data is retrieved." |
| 0:45 | Point at the summary card | "At the top is the spending for this month, the all-time total and the number of expenses, with a breakdown by category." |
| 1:05 | Tap **Add Expense** | "I will now add a new expense." |
| 1:10 | Save the empty form | "If the form is submitted empty, each field explains what is required." |
| 1:20 | Title "Lunch", amount `abc` | "The amount accepts only valid numbers; letters, negative values and more than two decimals are rejected." |
| 1:35 | Amount `18.50`, **Food**, today → **Add Expense** | "The expense is saved, and the total updates immediately." |
| 1:55 | Type "coffee" in search | "Search results update as I type." |
| 2:05 | Clear search → **Last month** → **Transport** | "Expenses can be filtered by period and by category, with the filtered total shown here." |
| 2:25 | Sort → **Highest amount** | "Sorting by amount shows the largest expenses first." |
| 2:35 | **Clear filters** → tap an expense | "Selecting an expense opens its details." |
| 2:45 | **Edit** → change amount → **Save Changes** | "From here it can be edited." |
| 3:00 | Swipe an expense left | "Deleting requires only a swipe…" |
| 3:10 | Tap **Undo** | "…and Undo restores it if it was a mistake." |
| 3:20 | Menu ⋮ → **Dark theme** | "The application supports a dark theme, and the choice is remembered." |
| 3:35 | Menu ⋮ → **Log out** → confirm | "Finally, logging out. All data is stored securely in the cloud and is visible only to its owner." |
| 3:50 | Back to the slides | "Let me now explain how the application is built." |

**If something fails live:** stay calm, say *"Let me show you the recorded
version"*, and play the video demo from the same step.

### Slide 7 – System architecture (1:00)
> "The application follows a layered architecture. The presentation layer
> handles only the user interface. The state layer uses the Provider package
> for application state and business logic. The service layer is the only part
> that communicates with the backend, Supabase, which provides authentication
> and a PostgreSQL database. Security is enforced in the database through Row
> Level Security, so each user can access only their own records."

### Slide 8 – Technology stack (0:40)
> "Flutter allows one codebase for Android and iOS. Provider manages shared
> state. Supabase provides authentication and a REST API over PostgreSQL.
> SharedPreferences stores the theme choice, and the official Flutter test and
> lint packages ensure code quality."

### Slide 9 – Quality assurance (0:50)
> "All 40 automated unit and widget tests pass, and static analysis reports
> zero issues. Every request has a 20-second timeout with clear error
> messages. Thirteen bugs were found and fixed during feature completion, and
> validation covers edge cases such as NaN, scientific notation, negative
> values and decimal commas."

### Slide 10 – Release and deployment (0:50)
> "I built a release APK of 51.3 megabytes and tested it on a Pixel 7a
> running Android 16. While preparing the release, I found that the INTERNET
> permission existed only in the debug configuration, so the release version
> could not reach the server. I added it to the main manifest and verified the
> fix. The project is fully documented with a README, API documentation, an
> architecture diagram and a release guide."

### Slide 11 – Lessons learned and future work (0:40)
> "This project taught me to separate an application into clear layers, to
> enforce security at the database level, to handle edge cases before release,
> and to always test the release build on a device. Future work includes
> monthly budgets with alerts, spending charts, receipt photos, and Excel
> export with offline synchronisation."

### Slide 12 – Thank you (0:20)
> "Thank you for your attention. I would be happy to answer any questions."

---

## 4. Likely questions and answers

| Question | Answer |
|---|---|
| Why Supabase and not Firebase? | Supabase gives a real SQL database (Postgres) with Row Level Security and an automatic REST API. It's open source and has a free tier. |
| Is the API key in the app a security risk? | No. It's the *publishable* key, designed to be public. Security comes from RLS policies in the database. The secret key is never in the app. |
| Why Provider and not Bloc / Riverpod? | It's the officially recommended simple option and fits an app of this size. The layers would make switching easy later. |
| Does it work offline? | It shows a clear message offline and keeps the loaded list. Full offline sync is a planned feature. |
| What was the hardest part? | Edge cases: amount parsing (`12,50`, `1e5`, `NaN`), duplicate sign-ups that Supabase hides, and the release-only INTERNET bug. |
| Who is it for? | Students and young professionals who want a quick, private way to track daily spending. |
| Can it run on iPhone? | Yes, it's Flutter. The iOS project is configured, and building needs a Mac with Xcode. |
| How did you test it? | Automated unit and widget tests, plus a 24-step manual checklist on a real phone with the release APK. |

---

## 5. Video demo (optional, but a strong backup)

**Length:** 90–120 seconds. **Format:** MP4, 1080p, portrait phone screen or phone inside a frame.

**Record with:**
- Android emulator: the ⋮ menu in the emulator toolbar → **Record screen**, or
- Real phone: the built-in **Screen recorder** (quick settings), or
- `scrcpy --record demo.mp4` (shows the phone on your PC and records it)

**Shot list:**

| # | Seconds | Shot | Caption on screen |
|---|---|---|---|
| 1 | 0–5 | App icon → app opens | Expense Tracker |
| 2 | 5–15 | Log in | Secure accounts with Supabase |
| 3 | 15–25 | Home summary card | See this month's spending at a glance |
| 4 | 25–45 | Add expense (show one validation error, then success) | Add an expense in seconds |
| 5 | 45–60 | Search, then Last month + category filter | Search & filter |
| 6 | 60–70 | Sort by highest | Sort |
| 7 | 70–80 | Edit from details | Edit anytime |
| 8 | 80–90 | Swipe delete → Undo | Swipe to delete, tap to undo |
| 9 | 90–100 | Switch to dark theme | Dark mode |
| 10 | 100–110 | Log out | Your data, only yours |
| 11 | 110–120 | End card | Flutter · Supabase · Provider — Thank you |

**Tips:** turn on "Show taps" (Developer options), use the seeded demo
account, record twice and keep the best take, add captions with any editor
(CapCut, Clipchamp, iMovie). No music is needed.
