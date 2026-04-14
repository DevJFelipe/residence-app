# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Residence App — a Flutter mobile app for condominium/residence management. Spanish-language UI. Supports admin and resident roles with different navigation shells.

## Development Commands

```bash
# Uses FVM (Flutter Version Management) — pinned to Flutter 3.41.6 via .fvmrc
fvm flutter pub get           # Install dependencies
fvm flutter analyze           # Lint check
fvm flutter test              # Run all tests
fvm flutter test test/widget_test.dart  # Run a single test file
fvm flutter run               # Run on connected device/emulator
fvm flutter run -d chrome     # Run on web
fvm flutter build apk --release   # Android release build
fvm flutter build ios --release   # iOS release build
```

## Architecture

**Layered structure with singletons, no DI framework or state management library.**

- **`lib/core/`** — Infrastructure singletons
  - `ApiClient`: Singleton Dio HTTP client, base URL `http://localhost:8000`, auto-injects Bearer token via interceptor
  - `SessionManager`: Singleton wrapping SharedPreferences for token/user persistence
- **`lib/models/`** — Data classes with manual `fromJson`/`toJson` (no code generation)
- **`lib/services/`** — Business logic calling ApiClient (e.g., `AuthService`, `DashboardService`). Instantiated directly in screens.
- **`lib/screens/`** — StatefulWidget screens using `setState()`. Two navigation shells:
  - `AdminShell` — IndexedStack bottom nav (Dashboard, Visitors, Billing, PQRS, More)
  - `UserShell` — IndexedStack bottom nav (Home, Amenities, Reservations, Profile)
- **`lib/theme/`** — `AppColors` and `AppTextStyles` (Google Fonts: Public Sans)
- **`assets/icons/`** — SVG icons rendered via `flutter_svg`
- **`assets/images/`** — PNG images

## Key Patterns

- **Auth flow**: 2-step PIN-based login. Email+password sends PIN to email, then PIN verification returns JWT. API prefix: `/api/v1/auth/`
- **Session gate**: `main.dart` has `_SessionGate` widget that checks stored session on startup and routes to `AdminShell`, `UserShell`, or `WelcomeScreen`
- **Role-based routing**: `LoginResponse.isAdmin` determines which shell to show. Navigation uses imperative `Navigator.push/pushReplacement/pushAndRemoveUntil` (no named routes)
- **Error messages**: Spanish-language user-facing strings. API errors parsed via `AuthService.parseError()`
- **Primary brand color**: `Color(0xFFEC5B13)` (orange)
