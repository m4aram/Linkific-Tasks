# Presentation Kit: Final Presentation Day

Everything needed to present Expense Tracker on presentation day: timing, a
word-for-word script, a 10-minute live demo with edge cases, the technical
part, the work and Git part, Q&A preparation and a backup plan.

**Presenter:** Maram Sharaf (individual project)
**Total time:** 25 minutes = about 20 minutes talking + 5 minutes Q&A
**Slides:** `Expense_Tracker_Final_Presentation.pptx` (18 slides, the script is also in the speaker notes)

---

## 1. Requirement checklist

| Required section | Time | Slides | ✓ |
|---|---|---|---|
| **Introduction**: project overview (the "team" is you) | 2 min | 1–4 | ☐ |
| **Live demo**: show all features | 10 min | 5–7 + phone | ☐ |
| ↳ User flows | | 7 + phone (Part A) | ☐ |
| ↳ Edge cases | | 8 + phone (Part B) | ☐ |
| **Technical discussion**: architecture | 5 min | 9–10 | ☐ |
| ↳ Challenges solved | | 11 | ☐ |
| ↳ Code walkthrough | | 12–13 | ☐ |
| **Collaboration**: work division | 3 min | 15 | ☐ |
| ↳ Git workflow | | 16 | ☐ |
| ↳ Learnings | | 17 | ☐ |
| **Q&A** | 5 min | 18 | ☐ |

---

## 2. Timing plan

| # | Slide | Section | Time | Clock |
|---|---|---|---|---|
| 1 | Title | Introduction | 0:20 | 0:20 |
| 2 | Agenda | Introduction | 0:20 | 0:40 |
| 3 | The problem | Introduction | 0:40 | 1:20 |
| 4 | The solution | Introduction | 0:40 | **2:00** |
| 5 | The screens | Demo | 0:30 | 2:30 |
| 6 | Demo overview | Demo | 0:20 | 2:50 |
| 7 | User flow → **phone, Part A** | Demo | 0:20 + 6:00 | 9:10 |
| 8 | Edge cases → **phone, Part B** | Demo | 0:10 + 2:40 | **12:00** |
| 9 | Architecture | Technical | 1:00 | 13:00 |
| 10 | Technology stack | Technical | 0:30 | 13:30 |
| 11 | Challenges solved | Technical | 1:15 | 14:45 |
| 12 | Code 1: amount validation | Technical | 0:45 | 15:30 |
| 13 | Code 2: RLS + provider | Technical | 1:00 | 16:30 |
| 14 | Quality assurance | Technical | 0:30 | **17:00** |
| 15 | Work division | Collaboration | 1:00 | 18:00 |
| 16 | Git workflow | Collaboration | 1:00 | 19:00 |
| 17 | Learnings | Collaboration | 1:00 | **20:00** |
| 18 | Thank you / Q&A | Q&A | 5:00 | **25:00** |

**Checkpoints:** at **12:00** you should be back on the slides after the demo,
and at **17:00** you should be starting slide 15. If you are late, shorten Part A
of the demo (skip the edit or the sort step). Never skip the edge cases, because
they are a required item.

---

## 3. Before you present: setup checklist

- [ ] Release APK installed on the demo phone (or emulator open), phone fully charged
- [ ] Screen mirroring tested (scrcpy / Android Studio "Running Devices" / projector cable)
- [ ] **Do Not Disturb** on, notifications off, "Show taps" on (Developer options)
- [ ] Internet working, with a hotspot as backup
- [ ] Logged **out**, so the demo starts on the login screen
- [ ] **Demo account** ready: `demo@expensetracker.app`, password written on paper
- [ ] Demo account has the seed data below
- [ ] A **second email** that is NOT registered, for the live sign-up (e.g. `maram.demo2@...`)
- [ ] Know how to turn on **Airplane mode** quickly (quick settings) for the offline edge case
- [ ] Backup video open in another window
- [ ] Slides in presenter mode, GitHub repo open in a browser tab (in case they ask to see code)
- [ ] VS Code / Android Studio open on `validators.dart` (in case they ask for more code)

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

## 4. Script

### Part 1: Introduction (2:00)

**Slide 1, Title (0:20)**
> "Good morning, everyone. Thank you for joining me. My name is Maram Sharaf,
> and today I am presenting my final project from the Flutter internship:
> Expense Tracker, a secure mobile application that helps people record their
> daily expenses and understand where their money goes."

**Slide 2, Agenda (0:20)**
> "The presentation takes about twenty-five minutes and has five parts. First,
> a short introduction to the problem and my solution. Then the main part, a
> ten-minute live demo with all features, a full user flow and the edge cases.
> After that, five minutes of technical discussion: architecture, the challenges
> I solved and some code. Then how I organised the work and used Git, and
> finally your questions."

**Slide 3, The problem (0:40)**
> "Most people know their income, but not exactly where it is spent. Small
> daily purchases such as coffee, transport and deliveries add up without being
> noticed. Notebooks and spreadsheets take effort, so people usually stop using
> them. And financial data is personal, so it must be protected. My objective
> was to build a fast, secure and easy-to-use mobile app for recording and
> analysing personal expenses."

**Slide 4, The solution (0:40)**
> "Expense Tracker answers this with six capabilities: secure accounts with
> sign-up, login and password reset; complete expense management in six
> categories; a monthly summary with a category breakdown; search, filters and
> sorting; safe deletion with Undo; and light and dark themes. Let me show you
> how it works."

### Part 2: Live demo (10:00)

**Slide 5, The screens (0:30)**
> "These are the main screens: login, account creation, password reset, the
> home screen with the summary and filters, the add-expense form, and the menu
> for theme and logout. Now let me show them live."

**Slide 6, Demo overview (0:20)**
> "The demo has two parts. First I will walk through every feature as one
> realistic user journey. Then I will deliberately try to break the app, to
> show how it handles edge cases."

**Slide 7, User flow (0:20)**
> "This is the journey I will follow: from creating an account to logging out."

Switch to the phone.

#### Demo Part A: Features and user flow (6:00)

| Time | Do | Say |
|---|---|---|
| 0:00 | Login screen → **Sign up** | "A new user starts here. I will create an account." |
| 0:10 | Enter new email, password, confirm → **Sign Up** | "The password needs at least six characters, and the two passwords must match." |
| 0:35 | Show the result (logged in, or "confirm your email" message) | "Depending on the Supabase setting, the user is logged in directly or asked to confirm the email first." |
| 0:50 | Log out → back on login screen → **Forgot password?** | "If a user forgets the password, they enter the email and receive a reset link." |
| 1:05 | Cancel the dialog | |
| 1:10 | Log in with the **demo account** | "Now I will use an account that already has some data. The session is remembered, so the user doesn't log in every time." |
| 1:25 | Point at the loading skeleton, then the summary card | "While loading, a placeholder appears. At the top: this month's spending, the all-time total and the number of expenses." |
| 1:45 | Point at the category bar | "This bar shows how the spending is split between categories, with percentages." |
| 2:05 | Tap **Add Expense** → "Lunch", `18.50`, **Food**, today → Save | "Adding an expense takes a few seconds: a title, the amount, a category and a date." |
| 2:35 | Watch the total animate | "The expense appears at the top and the total updates immediately." |
| 2:50 | Type "coffee" in search | "Search filters by title or category as I type." |
| 3:10 | Clear search → **Last month** | "I can filter by period: all time, this month or last month…" |
| 3:25 | → **Transport** | "…and by category. The header shows how many expenses match and their total." |
| 3:45 | Sort → **Highest amount** | "Sorting by highest amount shows the biggest expenses first." |
| 4:00 | **Clear filters** → tap an expense | "Tapping an expense opens its details." |
| 4:15 | **Edit** → change amount → **Save Changes** | "From here I can edit it. If I open the form and change nothing, the app doesn't even call the server." |
| 4:40 | Back on home → **swipe an expense left** | "To delete, I just swipe…" |
| 4:50 | Tap **Undo** | "…and if it was a mistake, Undo brings it back." |
| 5:05 | Details → **Delete** button | "From the details screen, deleting asks for confirmation first." Cancel. |
| 5:20 | Menu ⋮ → **Dark** | "The app supports light, dark or system theme, and remembers the choice." |
| 5:40 | Menu ⋮ → **Log out** → confirm | "Logging out closes all screens and clears the data of the previous user." |
| 6:00 | Back on slides | |

**Slide 8, Edge cases (0:10)**
> "Now the second part: what happens when things go wrong."

Switch to the phone again.

#### Demo Part B: Edge cases (2:40)

| Time | Do | Say |
|---|---|---|
| 0:00 | Login with a **wrong password** | "Wrong password: the user gets a clear message, never a technical error." |
| 0:15 | Sign up with the **demo email** again | "If someone signs up with an email that already exists, Supabase hides it for privacy, but my app detects it and says an account already exists." |
| 0:40 | Log in with demo account → **Add Expense** → tap Save empty | "An empty form: every field says what is required." |
| 0:55 | Amount `abc` → Save | "Letters are rejected…" |
| 1:05 | Amount `-5`, then `1e5`, then `12.345` | "…negative numbers, scientific notation and more than two decimals too." |
| 1:20 | Amount `12,50` → valid | "But a decimal comma is accepted, because many people type it that way." |
| 1:30 | Type a title, then press **Back** | "If I leave with unsaved changes, the app warns me." Choose Discard. |
| 1:45 | Turn on **Airplane mode** → pull to refresh / try to add | "With no internet, the app shows a friendly message and keeps the list I already loaded. Every request also has a 20-second timeout." |
| 2:15 | Turn Airplane mode **off** | |
| 2:25 | Back to the slides | "Let me now explain how the application is built." |

**If something fails live:** stay calm and say *"Let me show you the recorded
version."* Then play the video from the same step.

### Part 3: Technical discussion (5:00)

**Slide 9, Architecture (1:00)**
> "The app follows a layered architecture. The UI layer, screens and widgets,
> only draws the interface. The state layer uses Provider to hold the app
> state and business logic. The service layer is the only code that talks to
> the backend. The backend is Supabase: authentication plus a PostgreSQL
> database. Security is enforced in the database itself with Row Level
> Security, so each user can only access their own rows, even if someone calls
> the API directly."

**Slide 10, Technology stack (0:30)**
> "Briefly, the stack: Flutter for one codebase on Android and iOS, Provider
> for state, Supabase for authentication and a REST API on PostgreSQL,
> SharedPreferences for the theme choice, and the official test and lint
> packages for quality."

**Slide 11, Challenges solved (1:15)**
> "Here are three real problems I solved. First, parsing money: people type
> commas or dots, and Dart's parser also accepts values like NaN and 1e5, so I
> wrote my own validator, which I will show next. Second, Supabase hides
> duplicate sign-ups for privacy: it returns a user with no identities instead
> of an error, so the user thought registration worked. I check for that and
> show a clear message. Third, the release APK could not reach the internet,
> because the INTERNET permission was only in the debug manifest. I fixed it
> and re-tested on a real phone. The lesson: always test the release build."

**Slide 12, Code 1: amount validation (0:45)**
> "This is the real code from validators.dart. First, normalizeAmount decides
> what a comma means: one comma followed by one or two digits is a decimal
> comma, like 12,50; any other comma is a thousands separator, like 1,250.00.
> Then parseAmount checks a strict regular expression: only digits with up to
> two decimals. This whitelist rejects NaN, Infinity, 1e5 and negative numbers
> with one rule, instead of chasing special cases. Finally, the amount
> validator adds the business limits: greater than zero and at most one million.
> The form and the unit tests use exactly the same code."

**Slide 13, Code 2: RLS + provider (1:00)**
> "On the left is the database side. user_id has the default auth.uid(), so the
> database fills it, not the app. Row Level Security is enabled, and every
> policy checks that auth.uid() equals user_id, for select, insert, update and
> delete. On the right is the app side. addExpense calls the service with a
> 20-second timeout and inserts the result. The shared _save method prevents
> double submits, sets isSaving so the button shows a spinner, recalculates the
> totals once, turns any error into a friendly message, and the finally block
> always resets the loading state."

**Slide 14, Quality assurance (0:30)**
> "To make sure it all works: 40 automated unit and widget tests pass, static
> analysis reports zero issues, every request has a 20-second timeout, and I
> found and fixed 13 bugs during feature completion. I also tested the release
> APK on a Pixel 7a with a 24-step manual checklist."

### Part 4: Work division, Git and learnings (3:00)

**Slide 15, Work division (1:00)**
> "This was an individual project, so I covered every role myself: planning and
> UX, Flutter development, the Supabase backend, testing, and release and
> documentation. The work came as daily tasks from the program, and I delivered
> it in three milestones: version 1.0 with the core app, 1.1 with feature
> completion and tests, and 1.2 with the release build and full documentation.
> The mentors reviewed each task, and I used their feedback in the next one."

**Slide 16, Git workflow (1:00)**
> "For version control I used Git with a GitHub repository. For each task I
> made a small change locally, ran flutter analyze and flutter test, committed
> with a clear message and pushed. The milestones are versions 1.0, 1.1 and
> 1.2. Secrets such as the signing key are excluded with .gitignore. Because I
> worked alone, I did not need pull requests, but in a team I would use a
> feature branch for every task, pull requests with code review, CI running the
> tests, and rebasing on main to resolve conflicts."

> ⚠️ Make this slide match exactly what you did. If you used branches, say so.
> If you created Git tags for v1.0–v1.2, say "tagged"; if not, say "marked".

**Slide 17, Learnings (1:00)**
> "The most important things I learned: separate an app into clear layers;
> enforce security in the database, not only in the app; handle edge cases
> before release; always test the release build on a real device; plan in
> milestones and commit small changes; and write documentation as part of the
> work. Next, I would like to add monthly budgets with alerts, spending charts,
> receipt photos, and Excel export with offline sync."

### Part 5: Q&A (5:00)

**Slide 18, Thank you**
> "Thank you for your attention. I would be happy to answer your questions."

---

## 5. Q&A tips

- Listen to the whole question, pause for a second, then answer in 2–3 sentences.
- If the question is unclear: *"Just to make sure I understand, do you mean…?"*
- If you don't know: *"That's a good question. I haven't tried that yet, but
  this is how I would approach it…"* Never invent an answer.
- If they ask to see code, open the GitHub repo or the IDE.

---

## 6. Likely questions and answers

### About the project

| Question | Answer |
|---|---|
| Who is it for? | Students and young professionals who want a quick, private way to track daily spending. |
| What makes it different from existing apps? | It's simple and focused: no ads, no bank connection, and the data is protected per user at the database level. It's a learning project, but it's built and tested like a real release. |
| What would you add next? | Monthly budgets with alerts, then spending charts. Budgets are the most useful because they turn tracking into action. |

### Technical

| Question | Answer |
|---|---|
| Why Supabase and not Firebase? | Supabase gives a real SQL database (Postgres) with Row Level Security and an automatic REST API. It's open source and has a free tier. Expenses are relational data, so SQL fits well. |
| Is the API key in the app a security risk? | No. It's the *publishable* key, designed to be public. Security comes from the RLS policies in the database. The secret service_role key is never in the app. |
| What happens if someone calls the API directly with another user's ID? | RLS blocks it. Every policy checks `auth.uid() = user_id`, and `user_id` is filled by the database, so you cannot read or change another user's rows. |
| Why Provider and not Bloc or Riverpod? | It's the officially recommended simple option and fits an app of this size. Because the layers are separated, switching later would only affect the state layer. |
| Why a layered architecture? | Each layer has one job, so the code is easier to test and change. For example, the UI never calls Supabase directly. |
| How does Undo work? | The delete is optimistic: the item disappears immediately. Undo adds it back. If the server delete fails, the item returns to the same position with an error message. |
| How do you handle errors? | Every request has a 20-second timeout, and one function, `friendlyError`, turns technical errors into clear messages, for example no internet, wrong password or an already registered email. |
| Does it work offline? | It shows a clear message offline and keeps the already loaded list. Full offline sync is planned. |
| Why is `amount` `numeric(10, 2)` and not a float? | Money must be exact. Floating-point numbers can have rounding errors, so the database stores exactly two decimals. There is also a `check (amount > 0)`. |
| Can it run on iPhone? | Yes, it's Flutter. The iOS project is configured; building needs a Mac with Xcode. |
| How big is the app? | The release APK is 51.3 MB. It could be smaller with `--split-per-abi` or an App Bundle. |
| How did you test it? | 40 automated unit and widget tests, static analysis with zero issues, and a 24-step manual checklist on a real phone with the release APK. |
| What was the hardest part? | The edge cases: amount parsing, the hidden duplicate sign-ups and the release-only INTERNET bug. |

### Process and job-interview style

| Question | Answer |
|---|---|
| How did you organise your work alone? | Daily tasks from the program, grouped into three milestones. I finished and tested each step before moving on. |
| How do you use Git? | Small commits with clear messages, pushed to GitHub, secrets in .gitignore. In a team I'd add feature branches, pull requests and code review. |
| How would you resolve a merge conflict? | Pull the latest main, rebase my branch, open the conflicting files, keep the correct changes from both sides, run the tests and then push. |
| What would you do differently? | Write tests earlier, from the first feature, and test the release build earlier, not only at the end. |
| What did you learn about yourself? | That I enjoy finding edge cases and making the app robust, and that writing clear documentation saves time later. |

---

## 7. Backup video (90–120 s)

Record it the day before. It's your safety net if the live demo fails.

**Record with:** the emulator's ⋮ → **Record screen**, the phone's built-in
**Screen recorder**, or `scrcpy --record demo.mp4`.

| # | Seconds | Shot | Caption |
|---|---|---|---|
| 1 | 0–5 | App icon → app opens | Expense Tracker |
| 2 | 5–15 | Log in | Secure accounts with Supabase |
| 3 | 15–25 | Home summary card | See this month's spending at a glance |
| 4 | 25–45 | Add expense (one validation error, then success) | Add an expense in seconds |
| 5 | 45–60 | Search, then Last month + category filter | Search & filter |
| 6 | 60–70 | Sort by highest | Sort |
| 7 | 70–80 | Edit from details | Edit anytime |
| 8 | 80–90 | Swipe delete → Undo | Swipe to delete, tap to undo |
| 9 | 90–100 | Switch to dark theme | Dark mode |
| 10 | 100–110 | Log out | Your data, only yours |
| 11 | 110–120 | End card | Flutter · Supabase · Provider |

Turn on "Show taps", record twice and keep the best take. This video is also
great for your LinkedIn post and GitHub README (see `PORTFOLIO.md`).
