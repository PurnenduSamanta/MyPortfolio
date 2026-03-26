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

---

## ⚠️ 5. Active Issues & Fixes Needed

The following items are known bugs or features not working smoothly. Read this before attempting new features!

1. **Gestures/Swiping in Flutter Web**: 
   - *Issue*: Dragging the Notification Panel down from the top status bar or swiping the `AppGrid` is glitchy/unreliable using a mouse cursor in a browser environment. Standard web pointer events often conflict with Flutter's gesture arenas.
   - *Fix Needed*: We may need to refine mouse-drag sensitivity for `PageView` and `GestureDetector` (drag update) or implement fallback button clicks to explicitly open panels on desktop environments where trackpads aren't used.
2. **Google Sheet Link Missing**:
   - *Issue*: `lib/services/sheet_service.dart` is missing a valid Google Sheets published CSV link.
   - *Fix Needed*: Add the real URL to fetch portfolio data dynamically.
3. **External Dock Links**:
   - *Issue*: `dock_bar.dart` has GitHub and Email icons, but their `onTap` events are empty `() {}`.
   - *Fix Needed*: Update these to handle `url_launcher` intents.

---

## 🧠 Final Instruction to Agent

- Prioritize **UI quality over feature quantity.**
- Keep code **modular and clean.**
- Always ask yourself before modifying UI: *“Does this feel like a premium, real Android experience?”*
