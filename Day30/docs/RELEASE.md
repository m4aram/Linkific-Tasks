# Release Guide

How to build, sign, test and ship Expense Tracker.

| Output | Command | File |
|---|---|---|
| Release APK (install on phones) | `flutter build apk --release` | `build/app/outputs/flutter-apk/app-release.apk` |
| Split APKs (smaller, one per CPU) | `flutter build apk --release --split-per-abi` | `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` … |
| App Bundle (Google Play) | `flutter build appbundle --release` | `build/app/outputs/bundle/release/app-release.aab` |
| iOS | `flutter build ipa --release` (Mac only) | `build/ios/ipa/*.ipa` |

The version comes from `pubspec.yaml` → `version: 1.2.0+3`
(1.2.0 = version name shown to users, 3 = version code, which must go up on every Play upload).

---

## 1. Before building: pre-release checklist

- [ ] `lib/config/supabase_config.dart` points to the **real** Supabase project
- [ ] `supabase/schema.sql` has been run on that project (table + RLS policies)
- [ ] `android/app/src/main/AndroidManifest.xml` has the **INTERNET** permission (added in 1.2.0)
- [ ] App name is **Expense Tracker** (`android:label` in the manifest)
- [ ] `version:` in `pubspec.yaml` increased
- [ ] `flutter analyze` → **No issues found!**
- [ ] `flutter test` → **All tests passed!**
- [ ] No `print()` / test data / commented-out code left (`avoid_print` is an error in `analysis_options.yaml`)

> **Why the INTERNET permission matters:** Flutter adds it only to the
> *debug* manifest (`src/debug/AndroidManifest.xml`). Without it in the
> *main* manifest, the app works in `flutter run` but the release APK shows
> "No internet connection" on every request.

---

## 2. Create a release signing key (once)

The release build uses your own key when `android/key.properties` exists.
Without it, it falls back to the debug key, which is fine for installing on
your own phone for the demo but **not accepted by Google Play**.

**Windows (PowerShell):**

```powershell
keytool -genkey -v -keystore $env:USERPROFILE\upload-keystore.jks `
  -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**macOS / Linux:**

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

> If `keytool` is not found, use the one inside Android Studio:
> `"C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe"`.

Then create **`android/key.properties`**:

```properties
storePassword=<the password you chose>
keyPassword=<the password you chose>
keyAlias=upload
storeFile=C:\\Users\\<you>\\upload-keystore.jks
```

(On macOS / Linux: `storeFile=/Users/<you>/upload-keystore.jks`.)

⚠️ Keep the `.jks` file and passwords safe and **never commit them**. Both are
in `.gitignore`. If you lose the key you cannot update the app on Google Play.

`android/app/build.gradle.kts` already reads this file. No other change is needed.

---

## 3. Build

Easiest: the script runs clean → pub get → analyze → tests → APK → App Bundle
and prints where the files are.

```powershell
powershell -ExecutionPolicy Bypass -File scripts\build_release.ps1     # Windows
```
```bash
bash scripts/build_release.sh                                          # macOS / Linux
```

Or manually:

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build apk --release
flutter build appbundle --release
```

Optional, makes the code harder to reverse-engineer:

```bash
flutter build apk --release --obfuscate --split-debug-info=build/symbols
```

### Check the APK is signed with your key

```bash
# Android SDK build-tools
apksigner verify --print-certs build/app/outputs/flutter-apk/app-release.apk
```

The certificate should show **your** name, not `CN=Android Debug`.

---

## 4. Install on a phone

1. On the phone: **Settings → About phone → tap "Build number" 7 times** → Developer options → turn on **USB debugging**.
2. Connect with USB, then:

```bash
flutter install --release
# or
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

You can also send the APK file to the phone (WhatsApp / Drive / USB) and open
it, after allowing "Install unknown apps".

> If the phone already has the debug version, uninstall it first
> (`adb uninstall com.example.expense_tracker`), because the signatures differ.

---

## 5. Test the release build

Test on a **real phone**, with the **release** APK, not `flutter run`.
Mark each line ✅ / ❌ and note the phone model and Android version.

**Device:** ____________  **Android:** ____  **APK version:** 1.2.0 (3)  **Tester:** ________

| # | Flow | Steps | Expected | Result |
|---|---|---|---|---|
| 1 | Install & launch | Install APK, open app | Icon + name "Expense Tracker", login screen, no debug banner | |
| 2 | Sign up | New email + password | Account created (or "check your email") | |
| 3 | Duplicate sign-up | Same email again | "An account with this email already exists." | |
| 4 | Wrong password | Login with wrong password | "Incorrect email or password." | |
| 5 | Login | Correct details | Home with skeleton, then summary | |
| 6 | Forgot password | Tap "Forgot password?" | Reset email received | |
| 7 | Add expense | Title, amount `12,50`, Food, today | "Expense added", total = $12.50 | |
| 8 | Validation | Amount `abc`, `0`, `1e5`, `1.999`, empty title | Clear error under each field | |
| 9 | Edit | Change amount | "Expense updated", totals update | |
| 10 | Edit, no change | Open edit, save | "No changes to save" | |
| 11 | Unsaved changes | Type, press back | "Discard changes?" dialog | |
| 12 | Search | Type part of a title | List filters live | |
| 13 | Filters & sort | This month / Last month / category / Highest | Correct items and order | |
| 14 | Swipe delete + Undo | Swipe left, tap Undo | Expense removed, then restored | |
| 15 | Delete from details | Delete → confirm | Back to list, item gone | |
| 16 | Pull to refresh | Pull list down | Reloads without error | |
| 17 | Dark mode | Menu → Dark theme, restart app | Dark theme kept after restart | |
| 18 | Offline | Airplane mode, pull to refresh / add | "No internet connection…", list stays | |
| 19 | Session kept | Close app fully, reopen | Still logged in | |
| 20 | Log out | Menu → Log out → confirm | Login screen, old data gone | |
| 21 | Second user | Log in as another user | Sees only their own expenses | |
| 22 | Rotation / small screen | Rotate, large font size | No overflow (yellow/black stripes) | |
| 23 | Performance | Scroll a long list | Smooth, no lag | |
| 24 | APK size | Check file size | Note it here: ____ MB | |

---

## 6. iOS build (optional, needs a Mac)

iOS apps can only be built on macOS with Xcode.

1. On a Mac: install Xcode, then `sudo gem install cocoapods` (or `brew install cocoapods`).
2. `flutter pub get`, then `cd ios && pod install && cd ..`.
3. Open `ios/Runner.xcworkspace` in Xcode → **Runner → Signing & Capabilities**:
   - choose your **Team** (a free Apple ID works for your own iPhone)
   - change the **Bundle Identifier** from `com.example.expenseTracker` to a unique one
4. Run on a connected iPhone: `flutter run --release`.
5. For TestFlight / App Store (paid Apple Developer account): `flutter build ipa --release`,
   then upload `build/ios/ipa/*.ipa` with the **Transporter** app.

The display name is already **Expense Tracker** (`ios/Runner/Info.plist`).
No extra permission is needed. iOS allows HTTPS by default.

---

## 7. Publishing to Google Play (optional)

1. Change `applicationId` in `android/app/build.gradle.kts` from
   `com.example.expense_tracker` to something unique, for example
   `com.maramsharaf.expensetracker`. Play rejects `com.example`.
2. Create the signing key (section 2) and build the **App Bundle** (`.aab`).
3. Google Play Console → Create app → **Internal testing** → upload the `.aab`.
4. Fill in the store listing (screenshots are in `docs/screenshots/`), the privacy policy
   (the app stores email + expenses in Supabase), and the Data safety form.

---

## 8. Updating dependencies

```bash
flutter pub outdated                 # see what is out of date
flutter pub upgrade                  # newest versions allowed by pubspec.yaml
flutter pub upgrade --major-versions # also bumps the ^ constraints (check the changelogs!)
flutter analyze && flutter test      # always re-test after upgrading
```
