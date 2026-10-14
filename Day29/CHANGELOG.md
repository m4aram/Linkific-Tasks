# Changelog

## 1.2.0 (3) – Documentation & Deployment

### Fixed
- **Release builds could not reach Supabase.** The `INTERNET` permission was
  only in `android/app/src/debug/AndroidManifest.xml`. It is now in
  `android/app/src/main/AndroidManifest.xml`, so the release APK works.

### Added
- Comprehensive `README.md`: features, setup, architecture, API summary, troubleshooting
- `docs/API.md`: Supabase endpoints, request/response examples, errors, Dart service and provider API
- `docs/architecture.png` + Mermaid diagrams in the README
- `docs/RELEASE.md`: signing key, build commands, 24-step release test checklist, iOS and Google Play steps
- `docs/PRESENTATION.md`: speaking parts, demo script, Q&A, video demo plan
- `docs/screenshots/`
- `scripts/build_release.ps1` and `scripts/build_release.sh`
- Root `.gitignore` (keystores, `key.properties`, generated files)

### Changed
- Release signing reads `android/key.properties` when present (falls back to the debug key for demos)
- App name on Android: `expense_tracker` → **Expense Tracker**
- Version `1.1.0+2` → `1.2.0+3`
- Code cleanup: wrapped all lines to 80 columns (`dart format` style), added
  doc comments to the main classes, removed template comments from `build.gradle.kts`
- Removed machine-specific / generated files: `android/local.properties`,
  `android/.kotlin/` error logs, `*.iml`, `ios/Flutter/Generated.xcconfig`,
  `ios/Flutter/ephemeral/`, `flutter_export_environment.sh`, `GeneratedPluginRegistrant.*`
  (Flutter recreates them on the next build)
