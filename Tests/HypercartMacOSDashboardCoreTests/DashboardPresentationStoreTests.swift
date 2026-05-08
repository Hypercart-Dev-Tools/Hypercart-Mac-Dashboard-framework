import XCTest
@testable import HypercartMacOSDashboardCore

final class DashboardPresentationStoreTests: XCTestCase
{
    @MainActor
    func testNavigationSelectionAndDismissal() throws
    {
        let store = DashboardPresentationStore<String, String, String>()

        XCTAssertFalse(store.navigation.hasSelection)

        store.navigation.present("detail")

        XCTAssertTrue(store.navigation.hasSelection)
        XCTAssertEqual(store.navigation.selectedRoute, "detail")

        store.navigation.dismiss()

        XCTAssertFalse(store.navigation.hasSelection)
        XCTAssertNil(store.navigation.selectedRoute)
    }

    @MainActor
    func testAlertSheetAndConfirmationLifecycle() throws
    {
        let store = DashboardPresentationStore<String, String, String>()

        let alert = DashboardAlertState(
            title: "Network stalled",
            message: "The sync queue is not responding."
        )
        store.showAlert(alert)
        XCTAssertEqual(store.activeAlert?.title, "Network stalled")

        store.dismissAlert()
        XCTAssertNil(store.activeAlert)

        let sheet = DashboardSheetState(payload: "settings", showsTitleBar: false)
        store.showSheet(sheet)
        XCTAssertEqual(store.activeSheet?.payload, "settings")
        XCTAssertEqual(store.activeSheet?.showsTitleBar, false)

        store.dismissSheet()
        XCTAssertNil(store.activeSheet)

        let confirmation = DashboardConfirmationState(
            payload: "delete",
            title: "Delete item?",
            confirmLabel: "Delete",
            role: .destructive
        )
        store.showConfirmation(confirmation)
        XCTAssertEqual(store.activeConfirmation?.payload, "delete")
        XCTAssertEqual(store.activeConfirmation?.role, .destructive)

        store.dismissConfirmation()
        XCTAssertNil(store.activeConfirmation)
    }
}
