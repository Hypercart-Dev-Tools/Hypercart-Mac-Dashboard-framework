# Hypercart MacOS Dashboard

`hypercart-macos-dashboard` is a friendly extraction workspace for turning the reusable app-shell ideas inside Cork into a portable macOS SwiftUI package.

It is intentionally gitignored inside this repo. The point is to experiment safely: keep the useful scaffolding, leave the Homebrew-specific product logic behind, and prove the abstractions against real screen ports instead of theoretical notes.

## What this contains

- `Package.swift`
  - a standalone Swift package with buildable library and demo targets
- `Sources/HypercartMacOSDashboard`
  - umbrella target intended to be the friendly consumer-facing import surface
- `Sources/HypercartMacOSDashboardCore`
  - presentation state, navigation, alert/sheet/confirmation models, and runtime environment wiring
- `Sources/HypercartMacOSDashboardUI`
  - reusable macOS SwiftUI containers, AppKit bridges, and UI primitives
- `Sources/HypercartMacOSDashboardDemo`
  - a portability test app that ports real Cork screen shapes onto the extracted shell
- `ARCHITECTURE.md`
  - a running map of which Cork patterns moved cleanly and which still belong to app-specific code

## What this does not try to extract

- Homebrew package, tap, and service logic
- Cork licensing and network endpoints
- Cork assets, strings, and product branding
- product-specific workflows that only make sense inside Cork

## Portability tests completed

- Dashboard shell with sidebar/detail navigation
- General settings pane shape
- Notifications settings pane shape
- Discoverability settings pane shape
- Maintenance-style operational flow with ready/running/finished phases

These tests suggest the reusable boundary is real: the app-shell and settings infrastructure can travel, while the domain models and product logic should stay outside the package.

## Package direction

The package is starting to stabilize around four public layers:

- `HypercartMacOSDashboard`
  - umbrella import for downstream apps
- `HypercartMacOSDashboardCore`
  - navigation, presentation state, runtime environment, and operation-flow state
- `HypercartMacOSDashboardUI`
  - macOS SwiftUI/AppKit primitives and higher-level operation/status views
- `HypercartMacOSDashboardDemo`
  - a proving ground for porting real Cork screen shapes without importing Cork domain models

## Build

```sh
swift build
```

If this becomes a standalone package, the intended consumer import is:

```swift
import HypercartMacOSDashboard
```

The lower-level targets remain available for adopters who want a narrower dependency surface:

- `HypercartMacOSDashboardCore`
- `HypercartMacOSDashboardUI`

The demo executable is produced at:

```sh
.build/arm64-apple-macosx/debug/HypercartMacOSDashboardDemo
```

## Attribution

This extraction workspace is derived from patterns observed in Cork, created by David Bureš.

- Original project: <https://github.com/buresdv/Cork>
- Original author: David Bureš

This folder is not an official Cork component and should be treated as an independent experimental scaffold inspired by the architecture and UI patterns in that repository.
