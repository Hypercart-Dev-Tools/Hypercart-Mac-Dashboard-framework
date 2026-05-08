# Extraction Notes

This package skeleton is based on the reusable seams identified in Cork.

## High-value source patterns

- `Modules/Packages/PackagesModels/App State.swift`
  - reusable idea: app-wide presentation state, navigation state, alert/sheet/confirmation coordination
- `Modules/Shared/Dependencies/App Constants Dependency.swift`
  - reusable idea: environment wiring and DI boundary
- `Modules/Shared/App Constants.swift`
  - reusable idea: runtime environment container
  - not reusable as-is: Homebrew paths, licensing endpoints, Cork-specific persistence setup
- `Cork/View Modifiers/Stretched Pickers.swift`
  - reusable idea: macOS-specific compatibility view modifier
- `Cork/Views/Reusables/Settings/Settings Pane Template.swift`
  - reusable idea: settings pane container for macOS forms
- `Cork/Views/Reusables/Complex with Icon.swift`
  - reusable idea: icon + detail layout primitive
- `Cork/Views/Shared/Buttons/NSButton Port.swift`
  - reusable idea: AppKit button bridge for SwiftUI
- `Cork/Views/Shared/Inline Fatal Error.swift`
  - reusable idea: inline error surface with fallback for older macOS layouts
- `Cork/Views/Reusables/Sheets/Sheet Template.swift`
  - reusable idea: generic sheet container

## What belongs in the reusable layer

- navigation and route selection containers
- sheet / alert / confirmation presentation state
- generic loading-state models
- runtime environment container for logger/defaults/file system/notifications
- lightweight macOS SwiftUI containers and AppKit bridges

## Portability test performed

- Ported the structure of `Cork/Views/Settings/Panes/General Pane.swift` into the demo target as `DashboardDemoGeneralSettingsPane`.
- Replaced Cork-specific enums and `Defaults` bindings with demo-owned enums and local observable state.
- Confirmed the extracted `SettingsPaneTemplate`, `SheetContainer`, and presentation store can host a real Cork settings-screen shape without pulling in Homebrew or Cork model types.
- Ported the structure of `Cork/Views/Settings/Panes/Notifications Pane.swift` into the demo target as `DashboardDemoNotificationsSettingsPane`.
- Confirmed the shell also supports async environment-style state, permission-sensitive disabling, secondary explanatory UI, and sheet-contained settings composition.
- Ported the structure of `Cork/Views/Settings/Panes/Discoverability Pane.swift` into the demo target as `DashboardDemoDiscoverabilitySettingsPane`.
- Confirmed the shell also supports app-level loading gates, feature enable/disable cascades, and discoverability-style ranking controls without depending on Cork models.
- Added a maintenance-style operational flow inspired by `Cork/Views/Maintenance/*`.
- This required promoting operation-phase and operation-summary abstractions into reusable package APIs, which is a good sign that the package is moving from helper pile to real app-shell toolkit.

## What should stay app-specific

- Homebrew package/tap/service models
- shell command adapters
- licensing and auth endpoints
- app strings, assets, and workflow-specific enums
- persistence models whose shape only makes sense for Cork
