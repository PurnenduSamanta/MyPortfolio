# 🤖 Agent Context: Flutter Web Portfolio (Android Launcher Experience)

Welcome to the **Flutter Web Portfolio** project! This document serves as the unified context and memory for any AI agent working on this repository. Please read this file carefully before making any code changes.

---

## 🧭 1. Project Overview

This is a **Flutter Web portfolio website** designed to mimic a **modern Android launcher experience** (similar to Android 12+).
It is NOT a traditional portfolio website. The core goal is that the user feels like they are "interacting with a real Android phone GUI inside a browser."

**Key Concepts:**
- The entire UI behaves like an **Android home screen**.
- Projects are represented as **apps** in a grid.
- Clicking an app = opening an external link (GitHub / Play Store) in a new tab.
- "Resume" is a special system app on the home screen.
- Supported features: Dark/Light mode, Interactive Notification Panel, Google Sheets data parsing, App Search, App Grid Swiping.

**Platform Behavior:**
- **Desktop**: Centered phone UI frame (fixed width ~380px) with animated background orbs.
- **Mobile**: Full screen (no phone frame surrounding).

---

## 📦 2. Technical Stack & Architecture

- **Framework**: Flutter Web
- **Packages**: `http`, `url_launcher`, `shared_preferences` (for theme), `google_fonts`
- **Data Source**: Google Sheets (Published as CSV) - see `lib/services/sheet_service.dart`.

### Folder Structure Overview
```
lib/
├── main.dart                          # App entry point
├── core/
│   └── theme/                         # Light/Dark colors & ThemeProvider
├── data/
│   ├── model/                         # AppItem (Portfolio item model)
│   └── repository/                    # Caching & fallback data
├── services/
│   └── sheet_service.dart             # Google Sheets CSV fetcher
└── ui/
    ├── screens/
    │   ├── home_screen.dart           # Android home screen layout (status, search, grid, dock, notification stack)
    │   └── main_screen.dart           # Desktop frame + background orbs + responsive logic
    └── widgets/
        ├── app_grid.dart              # Horizontal page swiping + staggered icons
        ├── app_icon.dart              # Tap scale animation + dynamic gradients
        ├── dock_bar.dart              # Bottom dock (Theme toggle + Links)
        ├── notification_panel.dart    # Android 12+ pull-down panel with blur
        ├── search_bar_widget.dart     # Interactive name-based search field
        └── status_bar.dart            # Fake status bar with real time
```

---

## 🚫 3. Non-Goals (DO NOT Implement)

Avoid over-engineering. DO NOT implement:
- Complex backend servers.
- Heavy / flashy web transitions (keep it mobile-like, fast 200-300ms transitions).
- Fake Android Settings navigation or nested system menus.
- Real cross-app communication.

---

## 📅 4. Daily Progress Log

*Agents: Always append new updates to this section.*

### Day 1 – March 25, 2026
**Tasks completed:**
- Created initial Flutter Web structure and added `http`, `url_launcher`, `shared_preferences`, `google_fonts`.
- Implemented **Phase 1**: Phone frame UI + static app grid with fallback data.
- Implemented **Phase 2**: Dark/Light theme toggle with `shared_preferences` persistence and responsive mobile/desktop layouts.
- Implemented **Phase 3**: Google Sheets CSV parsing service.
- Implemented **Phase 4**: UI polish (staggered entrance animations, tap scale animations, animated theme orb toggle, animated background orbs, dynamic island notch).
- Updated SEO meta tags in `web/index.html`.

### Day 2 – March 26, 2026
**Tasks completed:**
- Made the **Search Bar interactive**: user can type and filter the App Grid in real time. Added a "Clear" (X) suffix icon.
- Upgraded the `AppGrid` to support **horizontal paging/swiping** using a `PageView` (groups of 20 icons). Added page indicator dots.
- Implemented **Notification Panel**: An Android 12+ style pull-down panel.
    - Includes Quick highlights (WiFi, Bluetooth, Notifications, Battery).
    - Includes Micro-storytelling section ("Daily Pulse").
    - Includes Tap-to-view Resume notification (Last updated: Jan 2026).
    - Includes a heavily blurred `BackdropFilter` background.
- Fixed **Issue #1 (Web Gesture Reliability)**:
    - Added explicit open/close notification actions to prevent drag-toggle jitter.
    - Added pull-down / swipe-up drag thresholds for stable panel interactions.
    - Enabled mouse drag devices globally for Flutter scrollables.
    - Added desktop fallback previous/next page controls for App Grid pagination.
- UI polish + dock behavior update:
    - Corrected Search Bar content alignment for icon/text vertical balance.
    - Wired dock GitHub/Email/LinkedIn icons to launch dummy links (theme toggle unchanged).
- Dev tooling fix:
    - Replaced invalid VS Code Chrome URL launcher with proper Flutter debug configurations in `.vscode/launch.json` (`Flutter (Chrome)` + `Flutter (Web Server)`).
- VS Code launch workflow updates:
    - Added Flutter browser launch profiles for Chrome/Edge and reordered configs so Chrome can be launched quickly from Run/F5.
    - Removed fixed web port binding from launch args to avoid local port-conflict startup failures.
- App Grid + icon stability/performance updates:
    - Added adaptive grid sizing to avoid bottom clipping in fullscreen layouts.
    - Removed heavy per-item page-entry animations and optimized icon repaint behavior to reduce left-right swipe lag on web.
    - Added overflow-safe icon tile scaling to fix `RenderFlex overflowed by 13 pixels on the bottom`.
    - Hardened Resume detection (`type` + name check) and normalized Resume icon rendering to keep it visually consistent.
- External links constants update:
    - Added centralized constants file `lib/core/constants/app_links.dart`.
    - Updated dock actions to use real links:
        - GitHub: `https://github.com/PurnenduSamanta?tab=repositories`
        - LinkedIn: `https://www.linkedin.com/in/purnendu9614/`
        - Email: `mailto:joysamanta84@gmail.com`
        - Google Play Console: `https://play.google.com/store/apps/developer?id=Purnendu+Samanta`
    - Added Google Play dock icon/action.

### Day 3 – March 27, 2026
**Tasks completed:**
- **Data Integration**: Wired `SheetService` with real Google Sheets CSV URL.
- **At a Glance Widget**: Implemented a premium `ResumeWidget` between the Search Bar and App Grid, mimicking the Google Pixel experience.
- **Exclusive Placement**: Filtered the "Resume" app out of the general `AppGrid` to keep it highlighted only in the new widget and notification panel.
- **Brand Identity**: Upgraded the Dock Bar with official brand icons (GitHub, LinkedIn, Email, Google Play) using `font_awesome_flutter`.
- **Dynamic Content**: Updated the Notification Panel to show a real-time auto-updating "Last Updated" date.
- **UI Consistency**: Standardized all app icons with a uniform 16px corner radius, ensuring network images fill the container and are clipped accurately.
- **Crash Fix**: Resolved "No Material widget found" error triggered during browser resizing by ensuring correct `Scaffold` wrapping at all breakpoints.
- **Web Rendering**: Fixed `FaIcon` visibility on web by explicitly passing theme colors to the icon widgets.

---

## ⚠️ 5. Active Issues & Fixes Needed

The following items are known bugs or features not working smoothly. Read this before attempting new features!

1. **Gestures/Swiping in Flutter Web**: 
   - *Issue*: Dragging the Notification Panel down from the top status bar or swiping the `AppGrid` is glitchy/unreliable using a mouse cursor in a browser environment. Standard web pointer events often conflict with Flutter's gesture arenas.
   - *Status*: ✅ Resolved on March 26, 2026 (thresholded gestures + explicit desktop fallback controls + web drag-device support).
2. **Google Sheet Link Missing**:
   - *Issue*: `lib/services/sheet_service.dart` is missing a valid Google Sheets published CSV link.
   - *Status*: ✅ Resolved on March 26, 2026 with real published CSV URL.
4. **"No Material widget found" crash on narrow browser resize**:
   - *Issue*: Resizing the browser below 600px switches from `_DesktopLayout` (which has a `Scaffold`) to a bare `HomeScreen` with no `Material` ancestor. Widgets like `TextField`, `InkWell`, `IconButton`, etc. all require a `Material` ancestor and crash.
   - *Status*: ✅ Resolved on March 26, 2026 by wrapping the mobile `HomeScreen` path in a `Scaffold`.
3. **External Dock Links**:
   - *Issue*: `dock_bar.dart` had empty / dummy link handlers.
   - *Status*: ✅ Resolved on March 26, 2026 with centralized real link constants and live URL launch actions.

---

## 🧠 Final Instruction to Agent

- Prioritize **UI quality over feature quantity.**
- Keep code **modular and clean.**
- Always ask yourself before modifying UI: *“Does this feel like a premium, real Android experience?”*
