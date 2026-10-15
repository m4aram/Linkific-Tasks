# Portfolio & Job Search Kit: Expense Tracker

Ready-to-use text for GitHub, LinkedIn, your CV and interviews.
Replace `<...>` with your own links.

---

## 1. GitHub repository polish

**About (the short description on the right side of the repo):**
> Personal expense tracker built with Flutter and Supabase: secure auth, Row Level Security, search, filters, monthly summary, Undo and dark mode. 40 tests.

**Website field:** a link to your demo video (YouTube unlisted or Google Drive), or your LinkedIn post.

**Topics:** `flutter` `dart` `supabase` `postgresql` `provider` `row-level-security` `mobile-app` `android` `expense-tracker` `material-design`

**Checklist**
- [✅] README has screenshots of all main screens (add home, details and dark mode)
- [✅ ] Demo GIF or video link at the top of the README
- [✅ ] **Releases → Create a release** `v1.2.0`, and attach `app-release.apk` so anyone can install it
- [✅ ] Pin the repo on your GitHub profile
- [✅ ] No secrets in the repo (`key.properties`, `*.jks`, service_role key)
- [✅ ] A clear license (MIT) if you want others to see it as open source
- [✅ ] Profile README (`<username>/<username>` repo) with a short intro and this project

---

## 2. LinkedIn post

> 🎉 I just presented my final project for the Flutter internship: **Expense Tracker**, a mobile app that helps people see where their money goes.
>
> 📱 **What it does**
> • Secure sign-up, login and password reset
> • Add, edit and delete expenses in 6 categories
> • Monthly summary with a category breakdown
> • Search, filters and sorting
> • Swipe to delete with Undo
> • Light and dark themes
>
> 🛠 **How it's built**
> Flutter + Provider on the app side, Supabase (Auth + PostgreSQL) on the backend. Every user's data is protected in the database itself with Row Level Security.
>
> 💡 **What I learned**
> • Edge cases matter: "12,50", "1e5" and "NaN" all needed handling in a simple amount field
> • Always test the release build: my release APK couldn't reach the internet because a permission existed only in debug mode
> • Clear layers make an app much easier to test and change
>
> ✅ 40 automated tests · 0 analyzer issues · release APK tested on a real device
>
> Thank you to my mentors for their feedback on every task 🙏
>
> 🔗 Code: <GitHub link>
> 🎥 Demo: <video link>
>
> #Flutter #Dart #Supabase #MobileDevelopment #PostgreSQL #Internship #OpenToWork

Attach the demo video (or 3–4 screenshots) to the post. Posts with video get much more reach.

**LinkedIn "Projects" section**
- **Name:** Expense Tracker
- **Description:** Flutter and Supabase mobile app for tracking personal expenses, with secure accounts, Row Level Security, search, filters, a monthly summary, Undo and dark mode. 40 automated tests; release APK tested on Android.
- **Skills:** Flutter · Dart · Supabase · PostgreSQL · Provider · Git
- **Link:** <GitHub link>

**Headline idea:**
> Flutter Developer | Dart · Supabase · Firebase | Building secure, tested mobile apps

---

## 3. CV / résumé

**Projects section**

> **Expense Tracker**, Flutter, Dart, Supabase, PostgreSQL · <GitHub link>
> - Built a cross-platform mobile app for tracking personal expenses, with authentication, full CRUD, search, filters, sorting and a monthly category summary.
> - Secured user data at the database level with PostgreSQL Row Level Security policies; the app ships only a publishable key.
> - Designed a layered architecture (UI → Provider state → service layer) with 20-second request timeouts and user-friendly error handling.
> - Wrote 40 unit and widget tests with zero static-analysis issues; found and fixed 13 bugs before release.
> - Diagnosed a release-only networking bug (missing INTERNET permission) and shipped a 51.3 MB release APK tested on Android 16.

**Skills line**
> **Mobile:** Flutter, Dart, Provider, Material 3 · **Backend:** Supabase, PostgreSQL, REST APIs, Row Level Security · **Tools:** Git, GitHub, Android Studio, VS Code · **Quality:** unit & widget testing, static analysis

---

## 4. Interview pitch

**30-second version** (for "Tell me about a project you're proud of")
> "In my Flutter internship I built Expense Tracker, a mobile app for tracking
> personal spending. It uses Flutter with Provider and a Supabase backend. What
> I'm most proud of is the robustness: data is protected with Row Level
> Security in the database, the app handles edge cases like invalid amounts,
> duplicate sign-ups and no internet, and it has 40 automated tests. I also
> caught a release-only bug where the APK couldn't reach the internet, which
> taught me to always test the release build."

**STAR story: a bug you solved**
- **Situation:** The app worked in debug, but the release APK showed "No internet connection".
- **Task:** Find out why before release.
- **Action:** I compared the debug and main Android manifests and found the INTERNET permission only in the debug one. I added it to the main manifest, rebuilt and tested on a real Pixel 7a.
- **Result:** The release works. I added "test the release build on a device" to my release checklist and documented it in the README troubleshooting section.

**STAR story: attention to detail**
- **Situation:** Users type money in different formats, and Dart's parser accepts values like `NaN` and `1e5`.
- **Task:** Accept real inputs and reject everything else.
- **Action:** I wrote a validator that normalises the comma (decimal vs thousands) and whitelists digits with up to two decimals, and covered it with unit tests.
- **Result:** `12,50` and `1,250.00` work; `abc`, `-5`, `1e5`, `NaN` and `12.345` are rejected with clear messages.

---

