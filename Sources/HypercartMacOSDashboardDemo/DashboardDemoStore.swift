import Foundation
import Observation
import OSLog
import HypercartMacOSDashboard

@Observable @MainActor
final class DashboardDemoStore
{
    var presentation: DashboardPresentationStore<DashboardDemoRoute, DashboardDemoSheet, DashboardDemoConfirmation> = .init()
    var environment: DashboardRuntimeEnvironment
    var loadState: DashboardLoadState<[DashboardDemoItem]> = .idle
    var maintenanceOperation: DashboardOperationStore<DashboardDemoMaintenanceStepID> = .maintenanceDemoDefault()
    var isCompactMetricsEnabled: Bool = false
    var isVerboseLoggingEnabled: Bool = true

    // Ported from Cork's General settings pane with domain-free stand-ins.
    var sortMode: DashboardDemoPackageSortMode = .name
    var displayOnlyPrimaryItemsByDefault: Bool = true
    var displayAdvancedDependencies: Bool = false
    var caveatDisplayMode: DashboardDemoCaveatDisplayMode = .full
    var showDescriptionsInSearchResults: Bool = true
    var outdatedInfoMode: DashboardDemoOutdatedInfoMode = .versionOnly
    var showPreviousVersionsInUpdateList: Bool = false
    var enableRevealInFinder: Bool = true
    var enableSwipeActions: Bool = true
    var enableExtraAnimations: Bool = false
    var showDependencySearchField: Bool = true
    var showInMenuBar: Bool = false
    var launchAtLogin: Bool = false
    var backupDateStyle: DashboardDemoBackupDateStyle = .numeric
    var areNotificationsEnabled: Bool = false
    var notificationDeliveryMode: DashboardDemoNotificationDeliveryMode = .badge
    var notifyAboutUpgradeResults: Bool = true
    var notifyAboutInstallResults: Bool = true
    var notifyAboutMassAdoptionResults: Bool = false
    var notificationAuthorizationState: DashboardDemoNotificationAuthorizationState = .notDetermined
    var enableDiscoverability: Bool = true
    var discoverabilityDaySpan: DashboardDemoDiscoverabilityDaySpan = .month
    var sortTopItemsBy: DashboardDemoTopItemSortMode = .popularity
    var allowMassPackageAdoption: Bool = false
    var hideAdoptableSectionWhenOnlyExcludedItemsRemain: Bool = false
    var isLoadingTopItems: Bool = false

    init()
    {
        self.environment = DashboardRuntimeEnvironment(
            logger: Logger(subsystem: "dev.hypercart.dashboard-demo", category: "Demo")
        )
        self.loadState = .loaded(Self.seedItems)
    }

    var items: [DashboardDemoItem]
    {
        switch loadState
        {
        case .loaded(let items):
            return items
        case .idle, .loading, .failed:
            return []
        }
    }

    var filteredItems: [DashboardDemoItem]
    {
        let query = presentation.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !query.isEmpty else
        {
            return items
        }

        return items.filter { item in
            item.name.localizedCaseInsensitiveContains(query)
                || item.summary.localizedCaseInsensitiveContains(query)
                || item.kind.rawValue.localizedCaseInsensitiveContains(query)
        }
    }

    var selectedItem: DashboardDemoItem?
    {
        guard case .item(let id) = presentation.navigation.selectedRoute else
        {
            return nil
        }

        return items.first(where: { $0.id == id })
    }

    func select(_ item: DashboardDemoItem)
    {
        presentation.navigation.present(.item(item.id))
        presentation.inlineErrorMessage = nil
    }

    func presentSettings()
    {
        presentation.showSheet(.init(payload: .settings, showsTitleBar: false))
    }

    func presentMaintenance()
    {
        maintenanceOperation.reset()
        maintenanceOperation = .maintenanceDemoDefault()
        presentation.showSheet(.init(payload: .maintenance, showsTitleBar: false))
    }

    func promptRemoval(of item: DashboardDemoItem)
    {
        presentation.showConfirmation(
            .init(
                payload: .removeItem(item.id),
                title: "Remove \(item.name)?",
                message: "This demonstrates a portable confirmation flow wired through the presentation store.",
                confirmLabel: "Remove",
                role: .destructive
            )
        )
    }

    func confirmRemoval()
    {
        guard let activeConfirmation = presentation.activeConfirmation else
        {
            return
        }

        switch activeConfirmation.payload
        {
        case .removeItem(let id):
            removeItem(id: id)
        }

        presentation.dismissConfirmation()
    }

    func dismissInlineError()
    {
        presentation.inlineErrorMessage = nil
    }

    func simulateInlineFailure()
    {
        environment.logger.error("Simulating a dashboard-level inline error")
        presentation.inlineErrorMessage = "The dashboard shell can surface a reusable inline error without any Cork-specific types."
    }

    func simulateAlert()
    {
        presentation.showAlert(
            .init(
                title: "Background refresh delayed",
                message: "This demonstrates a generic alert model routed through the extracted presentation store.",
                recoveryActionTitle: "Retry"
            )
        )
    }

    func refresh() async
    {
        environment.logger.info("Refreshing dashboard demo data")
        let currentItems = items
        loadState = .loading

        try? await Task.sleep(for: .milliseconds(500))

        let refreshedItems = currentItems.enumerated().map { index, item in
            var copy = item
            if index == 0
            {
                copy.status = .healthy
            }
            return copy
        }

        loadState = .loaded(refreshedItems)
    }

    func isMaintenanceStepEnabled(_ stepID: DashboardDemoMaintenanceStepID) -> Bool
    {
        maintenanceOperation.configuredSteps.first(where: { $0.id == stepID })?.isEnabled ?? false
    }

    func runMaintenanceDemo() async
    {
        maintenanceOperation.begin(withTitle: "Preparing maintenance plan…")

        var summary: [DashboardOperationSummaryItem] = []
        var foundNoProblems = true

        if isMaintenanceStepEnabled(.pruneArtifacts)
        {
            maintenanceOperation.updateCurrentStep(title: "Pruning stale artifacts…")
            try? await Task.sleep(for: .milliseconds(350))
            summary.append(.init(title: "Pruned stale artifacts", detail: "Removed 14 unused build artifacts from the demo workspace."))
        }

        if isMaintenanceStepEnabled(.clearDownloads)
        {
            maintenanceOperation.updateCurrentStep(title: "Clearing cached downloads…")
            try? await Task.sleep(for: .milliseconds(350))
            summary.append(.init(title: "Cleared cached downloads", detail: "Recovered 286 MB from the demo cache."))
        }

        if isMaintenanceStepEnabled(.validateSources)
        {
            maintenanceOperation.updateCurrentStep(title: "Running source health check…")
            try? await Task.sleep(for: .milliseconds(350))
            foundNoProblems = false
            summary.append(.init(title: "Source health check found warnings", detail: "Two stale index references were detected and should be refreshed."))
        }

        if summary.isEmpty
        {
            summary = [.init(title: "No maintenance steps were selected", detail: "Choose at least one step before starting the operation.")]
            foundNoProblems = false
        }

        maintenanceOperation.finish(summaryItems: summary, foundNoProblems: foundNoProblems)
    }

    func updateOutdatedInfoMode(_ newValue: DashboardDemoOutdatedInfoMode)
    {
        outdatedInfoMode = newValue

        switch newValue
        {
        case .none:
            showPreviousVersionsInUpdateList = false
        case .versionOnly:
            break
        case .all:
            showPreviousVersionsInUpdateList = true
        }
    }

    func refreshNotificationAuthorization() async
    {
        environment.logger.info("Refreshing simulated notification authorization state")

        try? await Task.sleep(for: .milliseconds(200))

        switch notificationAuthorizationState
        {
        case .notDetermined:
            notificationAuthorizationState = .authorized
            areNotificationsEnabled = true
        case .denied:
            areNotificationsEnabled = false
        case .authorized, .provisional, .ephemeral:
            break
        }
    }

    func updateNotificationToggle(_ isEnabled: Bool) async
    {
        areNotificationsEnabled = isEnabled

        if isEnabled
        {
            await refreshNotificationAuthorization()
        }
        else
        {
            environment.logger.info("Notifications disabled in demo settings")
        }
    }

    func applySimulatedNotificationAuthorizationState(_ state: DashboardDemoNotificationAuthorizationState)
    {
        notificationAuthorizationState = state

        if state == .denied
        {
            areNotificationsEnabled = false
        }
    }

    func updateDiscoverabilityEnabled(_ isEnabled: Bool)
    {
        enableDiscoverability = isEnabled

        if !isEnabled
        {
            allowMassPackageAdoption = false
        }
    }

    func simulateTopItemsRefresh() async
    {
        environment.logger.info("Refreshing simulated discoverability data")
        isLoadingTopItems = true

        try? await Task.sleep(for: .milliseconds(650))

        isLoadingTopItems = false
    }

    private func removeItem(id: UUID)
    {
        let remainingItems = items.filter { $0.id != id }
        loadState = .loaded(remainingItems)

        if case .item(let selectedID) = presentation.navigation.selectedRoute, selectedID == id
        {
            presentation.navigation.dismiss()
        }
    }

    private static let seedItems: [DashboardDemoItem] = [
        .init(
            name: "Catalog Sync",
            summary: "Pulls package metadata into the dashboard cache.",
            kind: .dataSource,
            status: .healthy,
            notes: [
                "Refresh cadence is controlled by the app shell.",
                "This would stay app-specific once backed by real APIs."
            ]
        ),
        .init(
            name: "Service Monitor",
            summary: "Aggregates running background jobs into a sidebar-friendly view.",
            kind: .service,
            status: .warning,
            notes: [
                "Portable shell concern: display and selection state.",
                "Non-portable concern: the service discovery backend."
            ]
        ),
        .init(
            name: "Cleanup Task",
            summary: "Executes a destructive maintenance action behind confirmation UI.",
            kind: .task,
            status: .failed,
            notes: [
                "Portable shell concern: confirmation and error presentation.",
                "Non-portable concern: the actual cleanup logic."
            ]
        )
    ]
}
