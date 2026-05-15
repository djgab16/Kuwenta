# Kuwenta

> Pera, pamilya, at tropa — lahat tinotrack.

Privacy-first personal finance app for Filipino users on iOS 18+. This repo
contains the **Phase 1 foundation** plus the multi-phase target roadmap from
the build plan.

## Open in Xcode

The project file (`Kuwenta.xcodeproj`) and source tree were generated on
Windows so you could lay out the scaffold ahead of time. To bring it up on a
Mac:

1. Copy this folder to a Mac with **Xcode 16+** installed.
2. Open `Kuwenta.xcodeproj`.
3. In the project navigator, select the **Kuwenta** target → **Signing &
   Capabilities** → set your **Team** and update the **Bundle Identifier**
   (default: `ph.kuwenta.app`).
4. Run the **Kuwenta** scheme on an iPhone simulator (iOS 18+).

The app boots into onboarding on first launch, then drops you into the
dashboard with three tabs (Bahay, Galaw, Settings). Categories seed
themselves on first launch via `CategorySeeder`.

## Project layout

```text
Kuwenta/
  Kuwenta.xcodeproj/           Xcode project (single workspace, single app target + tests)
  Kuwenta/                     iOS app sources
    App/                       Entry point, Info.plist, entitlements
    Core/
      Persistence/             Core Data + CloudKit stack, repositories, seeder
      DesignSystem/            Brand color + typography helpers
    Features/
      Onboarding/              Privacy-first onboarding flow
      Dashboard/               Pera sa bulsa card, category chips, recent tx
      Transactions/            Manual CRUD, category picker
      Settings/                Currency, month start day, sync placeholder
      Root/                    Tab container
    Support/                   Currency formatter, month math, preview helpers
    Resources/
      Assets.xcassets          Brand colors with light/dark variants
      Kuwenta.xcdatamodeld     Core Data model (Transaction, Category, MerchantRule, Account)
  KuwentaCore/                 Local Swift package (shared brand + parser stub)
  KuwentaTests/                Repository and seeder unit tests
  docs/PHASES.md               Per-phase target + capability roadmap
```

## Phase status

- **Phase 1 — Foundation** ✅ implemented in this commit.
- **Phase 2–6** — see `docs/PHASES.md` for the per-phase target list,
  capabilities, and entitlements to add when each phase begins.

## Honest constraints (don't fight Apple)

- **Apple Pay history is not readable** by third-party apps. Phase 2 leans on
  the **Message Filter Extension** for SMS-based ingestion.
- **Subscriptions cannot be auto-cancelled.** The Sub Watch flow only warns
  and deep-links to the service's own cancel page.
- **Wi-Fi Aware** for tropa proximity is treated as future / unverified —
  fall back to share links + GCash QR codes.
- **Apple Intelligence** features are device-gated; gate at runtime and
  degrade gracefully.

## License

TBD.
