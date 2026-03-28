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
├── main.dart                           # App entry point
├── core/
│   ├── constants/                      # Centralized links, data sources, colors, gradients, spacing, durations
│   └── theme/                          # Theme setup + ThemeProvider
├── data/
│   ├── model/                          # AppItem (Portfolio item model)
│   └── repository/                     # Caching & fallback data
├── services/
│   ├── sheet_service.dart              # Google Sheets CSV fetcher (uses AppLinks.googleSheetCsvUrl)
│   └── quote_service.dart              # Random quote fetcher (DummyJSON API + local fallback)
└── ui/
    └── screens/
        ├── boot_sequence/
        │   ├── boot_sequence_screen.dart
        │   ├── boot_sequence_view_model.dart
        │   └── widgets/
        │       └── boot_view.dart
        ├── home/
        │   ├── home_screen.dart
        │   ├── home_view_model.dart
        │   └── widgets/
        │       ├── app_grid.dart
        │       ├── app_icon.dart
        │       ├── dock_bar.dart
        │       ├── navigation_bar_widget.dart
        │       ├── notification_panel.dart
        │       ├── resume_widget.dart
        │       ├── search_bar_widget.dart
        │       └── status_bar.dart
        ├── main/
        │   ├── main_screen.dart
        │   ├── main_view_model.dart
        │   └── widgets/
        │       └── main_desktop_layout.dart
        └── project_detail/
            ├── project_detail_screen.dart
            ├── project_detail_view_model.dart
            └── widgets/
                ├── project_detail_components.dart
                ├── project_navigation_bar_widget.dart
                └── project_status_bar_widget.dart
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
- **OS Boot Experience**: Added a startup boot sequence screen with branding, animated loading progress, intro headline ("Hi, I am Purnendu Samanta"), and automatic transition into the home launcher UI. On desktop, this now renders inside the phone frame (not full browser screen).
- **Profile Hook**: Wired the boot avatar to load from `web/profile/purnendu.jpg` with a graceful fallback icon when the image is not yet present.
- **Boot Visual Upgrade**: Enhanced the startup experience with a more modern Android-like aesthetic (animated dual rings around profile, staged module loader chips, dynamic boot percentage, moving light streaks, and richer progress-bar glow).
- **Project Open Flow Upgrade**: Changed app icon taps to open a full in-app `ProjectDetailScreen` first (Android app-open feel), then redirect to external project links via an explicit "Open Actual Project" action.
- **Dummy Project Metadata Layer**: Added placeholder project overview/tech-stack/highlights data model in the detail screen to be replaced later by Google Sheets-driven content.
- **Detail Screen UX Refinement**: Updated the project detail page to feel like it is still inside the Android OS shell by reusing launcher-style status/navigation bars and surface cards.
- **Real App Icon Rendering**: Replaced generic hero icon usage in detail view with actual app icon loading (`iconUrl`) plus robust fallback icon states.
- **In-Phone Navigation Flow**: Removed route-level full-page takeover for project detail and now render details inline inside `HomeScreen` so desktop keeps the phone frame visible while detail content scrolls within the mobile UI.
- **MVVM Refactor**: Introduced a ViewModel layer under `lib/ui/viewmodels` and migrated state/business logic out of UI screens:
    - `HomeViewModel`: app loading/filtering, active project state, notification state machine, and interaction events.
    - `BootSequenceViewModel`: startup transition timing and boot completion state.
    - `ProjectDetailViewModel`: project detail data source (dummy for now) and external project open action.
- **Per-Screen MVVM Module Structure**: Reorganized UI into screen-specific modules (each screen has its own `screen + viewmodel + widgets/` subtree), replacing the shared global `ui/widgets` + `ui/viewmodels` layout.
- **Constants Consolidation (Design Tokens)**:
    - Added centralized constants in `lib/core/constants` for links, sheet source URL, durations, spacing/radius/sizes, colors, and gradients.
    - Removed hardcoded `Duration`, `Color(0x...)`, `EdgeInsets(...)`, and external URL literals from screen/widget files; they now resolve from constants.
    - `SheetService` now reads the CSV URL from `AppLinks.googleSheetCsvUrl`.
- **View Simplification**: Refactored `HomeScreen`, `BootSequenceScreen`, and `ProjectDetailScreen` to focus on rendering and delegate logic/actions to their respective ViewModels.

### Day 4 – March 28, 2026
**Tasks completed:**
- **Boot Screen Profile Image**: Integrated dynamic profile image fetching from Google Sheet into the boot sequence.
    - Updated `AppItem` model to parse a `ProfileImage` column from the CSV.
    - Implemented a `_processImageUrl` utility to convert Google Drive share links into direct-serve `lh3.googleusercontent.com` URLs (CORS-compatible for Flutter Web).
    - `BootSequenceViewModel` holds the transition until both the boot animation and image precaching complete (with a 10s safety timeout).
    - Profile image fades in smoothly using `frameBuilder` + `AnimatedOpacity` (800ms ease-in).
- **Music Player Resume Widget**: Redesigned the `ResumeWidget` on the home screen as an Android-style media player widget.
    - Profile image as album art with gradient fallback.
    - Animated "Now Playing" equalizer bars (3-bar pulse animation).
    - Toggleable Play/Pause that controls progress bar and equalizer animations.
    - Decorative Skip Previous/Next buttons.
    - Animated progress bar with time labels (loops over 40s).
    - Tap anywhere on the widget to open the resume link.
- **Daily Pulse – Random Quotes**: Added live random quotes to the Notification Panel's "Daily Pulse" section.
    - Created `QuoteService` (`lib/services/quote_service.dart`) with DummyJSON API integration (`dummyjson.com/quotes/random`) — CORS compatible.
    - Includes 15 curated local fallback quotes for instant display when the API fails.
    - Quote data flows through the MVVM architecture: `QuoteService` → `HomeViewModel` → `NotificationPanel`.
    - Quote is loaded synchronously (local) on panel open, then silently upgraded with an API quote in the background.
- **Notification Panel MVVM Fix**: Fixed a critical bug where the notification panel always showed empty quote text.
    - Root cause: The drag-to-open path (`onStatusBarDragUpdate`) bypassed `openNotif()` entirely, never setting `_quote`.
    - Extracted shared `_prepareQuote()` method called by both tap and drag open paths.
    - Moved `NotificationPanel` from `AnimatedBuilder`'s `child` parameter (rebuild-proof cache) into the `builder` callback to ensure fresh ViewModel data on every rebuild.
- **Real ProjectDetailScreen Data**: Wired `ProjectDetailScreen` to display real project data from Google Sheet.
    - Added 3 new fields to `AppItem`: `overview` (String), `techStacks` (List<String>), `highlights` (List<String>).
    - TechStacks and Highlights use pipe-separated (`|`) values in a single cell, parsed into lists via `split('|')`.
    - Updated CSV column order: `Name, IconUrl, Link, Type, Overview, TechStacks, Highlights, ProfileImage`.
    - `ProjectDetailViewModel` uses real data when available, falls back to dummy data when fields are empty.
    - Top bar badge dynamically shows "Live" vs "Preview" based on data availability.
- **Cleanup**: Removed profile avatar from status bar (now lives in music player widget). Removed all temporary debug prints.
- **3D Phone Frame (Desktop)**: Redesigned the desktop phone frame with a realistic 3D appearance.
    - Added physical **Volume Up / Volume Down** buttons on the left side and a **Power button** on the right.
    - Side buttons use metallic gradients matching the frame color with drop shadows for depth.
    - Frame uses a **silver metallic finish** with beveled edge gradient (highlight → silver → shadow) on both dark and light themes.
    - Enhanced shadow system: primary glow + deep drop shadow + tight contact shadow + left-edge highlight for a floating effect.
    - Added a subtle **screen reflection** gradient at the top-left of the display for glass-like realism.
    - Added a **speaker grill** in the top bezel — a 56px pill-shaped slit with 10 vertical bars simulating a real speaker mesh.
    - Cleaned up the Dynamic Island — removed the camera lens circle, now a clean solid black pill.
- **App Grid Pagination Fix**: Fixed a regression where all app icons were shrinking to fit on a single page.
    - Reduced `_iconsPerPage` from 20 (5 rows) to 16 (4 rows of 4 columns).
    - Replaced dynamic `LayoutBuilder` + adaptive aspect ratio with a fixed `childAspectRatio: 0.85` for consistent icon sizing.
    - Icons now maintain a comfortable size; extra icons properly overflow to swipeable pages.

---

## ⚠️ 5. Active Issues & Fixes Needed

The following items are known bugs or features not working smoothly. Read this before attempting new features!

1. **Gestures/Swiping in Flutter Web**: 
   - *Issue*: Dragging the Notification Panel down from the top status bar or swiping the `AppGrid` is glitchy/unreliable using a mouse cursor in a browser environment. Standard web pointer events often conflict with Flutter's gesture arenas.
   - *Status*: ✅ Resolved on March 26, 2026 (thresholded gestures + explicit desktop fallback controls + web drag-device support).
2. **Google Sheet Link Missing**:
   - *Issue*: Google Sheets source URL was previously hardcoded/unstable across files.
   - *Status*: ✅ Resolved on March 27, 2026 by centralizing the published CSV URL in `lib/core/constants/app_links.dart` and consuming it from `SheetService`.
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
