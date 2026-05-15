# Per-phase Xcode roadmap

This document is the operational checklist for adding targets, capabilities,
and entitlements as each phase from the Kuwenta build plan begins.
Phase 1 is implemented; everything below Phase 1 is intentionally not wired
yet to keep the surface area small.

## Phase 1 — Foundation (this commit)

| Item | Status |
|------|--------|
| App target `Kuwenta` (SwiftUI, iOS 18+) | ✅ |
| Core Data model `Kuwenta.xcdatamodeld` (Transaction, Category, Account, MerchantRule) | ✅ |
| `NSPersistentCloudKitContainer` wired (CloudKit toggled OFF until you enable iCloud capability) | ✅ |
| `KuwentaCore` Swift package (shared brand tokens + SMS parser stub) | ✅ |
| Onboarding (welcome / privacy / later permissions) | ✅ |
| Dashboard (Pera sa bulsa, category chips, recent tx) | ✅ |
| Transactions (list, add, delete) | ✅ |
| Settings skeleton (currency, month start day, sync placeholder) | ✅ |
| Color assets with light/dark variants | ✅ |
| Unit tests for seeder + repository | ✅ |

### Before you ship Phase 1

1. Add a real **AppIcon** asset set (1024×1024 + iOS sizes). The placeholder
   `AppIcon.appiconset` is empty.
2. In **Signing & Capabilities**, optionally enable **iCloud → CloudKit** and
   set `cloudKitEnabled = true` in `PersistentCloudKitController`.
3. Create the matching CloudKit container (`iCloud.ph.kuwenta.app`) in the
   Apple Developer portal.

## Phase 2 — SMS Auto-Log (Weeks 3–4)

Add **two** new targets and one capability.

| Target | Type | Notes |
|--------|------|-------|
| `KuwentaMessageFilter` | Message Filter Extension | New target → File → New → Target → **Message Filter Extension**. Bundle ID `ph.kuwenta.app.MessageFilter`. |
| (existing) `KuwentaCore` | Swift package | Move `Kuwenta.xcdatamodeld` here so both app and extension share it. |

Capabilities to add:

- App target: **App Groups** (`group.ph.kuwenta.app`) so the extension can
  write parsed transactions into a shared store.
- Extension target: **App Groups** with the same identifier.

Code changes:

- Implement `SMSParser.parse` in `KuwentaCore` with per-issuer regexes
  (BDO, GCash, Maya).
- Switch `PersistentCloudKitController` to load the store from the App Group
  container URL.
- Build the **Needs review** inbox screen for unclear classifications.

## Phase 3 — Wallet, Widgets, Live Activity, Watch (Weeks 5–6)

| Target | Type | Notes |
|--------|------|-------|
| `KuwentaWidgets` | Widget Extension | Lock Screen + Home Screen widgets. ActivityKit Live Activity for sahod countdown lives here too. |
| `KuwentaWatch Watch App` | watchOS App | Companion + complication. Use `WatchConnectivity` for live syncing of `topCategories`. |
| (server, not Xcode) Pass Web Service | external | PassKit pass push updates require a backend with APNs certs. |

Capabilities to add:

- App + Widget: **WidgetKit**, **Push Notifications** (for pass updates &
  optional rich notifications), **Background Modes → Remote notifications**.
- App: **Wallet** capability for `PKPass` add flows.

## Phase 4 — Subscriptions + Padala (Weeks 7–8)

No new targets — all flows live in the app.

Capabilities to add:

- **User Notifications** (already implicit) for renewal warnings and padala
  reminders.
- **Background Tasks** (`BGTaskSchedulerPermittedIdentifiers` in `Info.plist`)
  for periodic subscription scans.
- **Family Controls** (Screen Time API) — *optional*; requires Apple
  entitlement request to track real subscription usage.

## Phase 5 — Tropa Bill Split + Siri (Weeks 9–10)

| Target | Type | Notes |
|--------|------|-------|
| (in app) | App Intents | `AppIntent` types live in the main app target with the `AppShortcutsProvider`. |
| `KuwentaShare` (optional) | Share Extension | If you want users to share a receipt from Photos directly into the split flow. |

Capabilities to add:

- **Siri** (App Intents auto-register; flip the capability on for older
  Shortcuts compatibility).
- **Speech Recognition** + **Microphone** (`NSSpeechRecognitionUsageDescription`,
  `NSMicrophoneUsageDescription` in `Info.plist`) for Kausap Mode.
- **Contacts** (`NSContactsUsageDescription`) for tropa picker.
- **Camera** (`NSCameraUsageDescription`) + **Photo Library** for Vision OCR
  on receipts.

Wi-Fi Aware (iOS 26+ in the spec) is treated as **unverified** — implement
share links + GCash QR codes as the shippable path; revisit once Apple ships
documentation.

## Phase 6 — Polish (Weeks 11–12)

- Profile with **Instruments** (Time Profiler + Allocations) on a real
  device.
- Run **Accessibility Inspector** with VoiceOver and large Dynamic Type.
- TestFlight with 50 Filipino users; gate Apple Intelligence features behind
  runtime device checks (`SystemLanguageModel.availability` on capable
  devices) and degrade gracefully on the rest.
