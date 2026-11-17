# Household Finance Manager

Offline-first Flutter app for household finances: unlimited wallets, income/expense/transfers, wallet groups (combined views), assets & liabilities, and net worth.

**Phase 1 (MVP)** is implemented. Phases 2–4 are planned (see below).

## Tech stack

- Flutter + Dart (null-safe)
- State: Riverpod
- Local DB: SQLite via Drift (UUID PKs, soft delete, sync-ready timestamps)
- Navigation: go_router
- Charts: fl_chart
- Localization: English + Urdu (`flutter gen-l10n`)
- Money: integer minor units (paisa), never floating-point doubles

## Architecture

```
lib/
  core/        theme, router, utils, shared widgets
  data/        Drift tables/DAOs, mappers, repositories, seed
  domain/      models, enums, pure calculation services
  features/    UI + Riverpod providers (feature-first)
  l10n/        ARB localization files
```

UI → providers → repositories → DAOs. Balance, group totals, and net worth live in `domain/services` and are unit-tested.

### Core money rules

1. Wallet balance is **never** stored as an editable field.  
   `balance = opening_balance + income − expense + transfers_in − transfers_out`
2. Transfers are **not** income or expense.
3. Soft delete via `is_deleted`.
4. Net worth (convention A): non-CC wallet balances + assets − liabilities − CC wallet balances.

## Setup

1. Install [Flutter](https://docs.flutter.dev/get-started/install) (stable), or use the SDK at `C:\src\flutter` if already cloned for this project.
2. Add Flutter to PATH: `C:\src\flutter\bin`
3. **Windows:** enable Developer Mode (Settings → Privacy & security → For developers) so plugin symlinks work.
4. From this folder:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter run -d windows
```

### Tests

```bash
flutter test
```

Debug builds seed sample wallets, transactions, gold asset, bike loan, and a "Ghar ke Kharche" group.

## Phase 1 status

**Built**

- App shell with bottom nav (Dashboard, Transactions, Wallets, Assets & Debts, More)
- Light / dark / system theme (Material 3)
- Wallets CRUD + archive + soft delete; live calculated balances
- Transactions: income / expense / transfer with search & filters
- Default household categories + user-created categories
- Wallet groups + combined view + quick select
- Dashboard: totals, month income/expense, wallet breakdown, pie chart, recent txs, net worth
- Simple assets & liabilities
- EN / UR localization scaffolding
- Unit tests for balance, transfers, net worth, group totals
- Backup and restore: local JSON/CSV, optional password encryption, Google Drive app folder
- About screen (version, privacy, developer)

**Not in Phase 1** (planned later)

- Budgets, recurring txs, local notifications
- Liability payment auto-reduction, asset value history / gold rate tracker
- Udhaar, BC committees, savings goals, reports, PDF/CSV export
- Cloud sync, family sharing, zakat

## Google Drive backup setup

Backups use only the hidden Drive app folder (`https://www.googleapis.com/auth/drive.appdata`). The app cannot read or change the rest of the user's Drive. Sign-in is optional. Local JSON and CSV export work without Google.

1. Open [Google Cloud Console](https://console.cloud.google.com/) and create a project (or pick an existing one).
2. **APIs & Services → Library**. Enable **Google Drive API**.
3. **APIs & Services → OAuth consent screen**.
   - User type: External (or Internal for a Workspace org).
   - Add the app name **Household Finance Manager**, a support email, and the developer contact.
   - On the scopes step, add only `https://www.googleapis.com/auth/drive.appdata` (Google Drive API → See and download its own configuration data). Do not add full `drive` or `drive.file` scopes.
   - Add your Google account as a test user while the app is in testing.
4. **APIs & Services → Credentials → Create credentials → OAuth client ID**.

### Android

1. Create an **Android** OAuth client.
2. Package name: `com.household.household_finance_manager` (this is the current `applicationId`).
3. SHA-1 of the keystore that signs the build:
   ```bash
   cd android
   ./gradlew signingReport
   ```
   Copy the SHA-1 under `Variant: debug` (and the release keystore SHA-1 before you ship).
4. Download `google-services.json` only if you use the Google Services Gradle plugin. `google_sign_in` can also work with the OAuth client registered for that package name and SHA-1.

### iOS

1. Create an **iOS** OAuth client with your bundle id.
2. In Xcode, open `ios/Runner/Info.plist` and add:
   - `GIDClientID` = the iOS client id (`....apps.googleusercontent.com`)
   - `CFBundleURLTypes` → a URL scheme that is the reversed client id (`com.googleusercontent.apps....`)
3. Add the Drive app-data scope only; the app requests it in code.

### Web

1. Create a **Web** OAuth client.
2. Authorized JavaScript origins: `http://localhost:<port>` for local runs, plus your production origin.
3. Pass the client id when you run or build:
   ```bash
   flutter run -d chrome --dart-define=GOOGLE_WEB_CLIENT_ID=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com
   ```
   If that id is missing, the Backup screen hides Google sign-in and keeps local export.

### After setup

Sign in from **More → Backup**, then **Back up now**. Drive keeps the newest 5 files in `appDataFolder`. Restore asks you to **Replace all data** or **Merge by id**, and writes a local safety copy first. If you turn on encryption, store the password somewhere safe: a forgotten password cannot be recovered.

Replace the placeholder feedback, privacy, and terms links in `lib/features/about/presentation/about_page.dart` (`AboutLinks`) before you publish.

## Suggested next steps (Phase 2)

1. Monthly budgets with 80%/100% warnings  
2. Recurring transactions + reminders  
3. Liability payment flow (one entry → tx + remaining ↓)  
4. Asset value history chart  

## License

Private / unpublished (`publish_to: none`).
