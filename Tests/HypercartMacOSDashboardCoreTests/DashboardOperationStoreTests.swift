import XCTest
@testable import HypercartMacOSDashboardCore

final class DashboardOperationStoreTests: XCTestCase
{
    enum Step: String, Hashable, Sendable
    {
        case first
        case second
    }

    @MainActor
    func testCanStartDependsOnEnabledStepsAndPhase() throws
    {
        let store = DashboardOperationStore<Step>(
            configuredSteps: [
                .init(id: .first, title: "First", isEnabled: false),
                .init(id: .second, title: "Second", isEnabled: false)
            ]
        )

        XCTAssertEqual(store.phase, .ready)
        XCTAssertFalse(store.canStart)

        store.updateStep(id: .first, isEnabled: true)
        XCTAssertTrue(store.canStart)

        store.begin(withTitle: "Running")
        XCTAssertEqual(store.phase, .running)
        XCTAssertFalse(store.canStart)
    }

    @MainActor
    func testFinishAndResetLifecycle() throws
    {
        let store = DashboardOperationStore<Step>(
            configuredSteps: [
                .init(id: .first, title: "First", isEnabled: true)
            ]
        )

        store.begin(withTitle: "Executing step")
        store.updateCurrentStep(title: "Validating")

        XCTAssertEqual(store.currentStepTitle, "Validating")
        XCTAssertEqual(store.phase, .running)

        store.finish(
            summaryItems: [
                .init(title: "Finished first step", detail: "All outputs were generated.")
            ],
            foundNoProblems: false
        )

        XCTAssertEqual(store.phase, .finished)
        XCTAssertEqual(store.summaryItems.count, 1)
        XCTAssertFalse(store.foundNoProblems)

        store.reset()

        XCTAssertEqual(store.phase, .ready)
        XCTAssertEqual(store.currentStepTitle, "Waiting")
        XCTAssertTrue(store.summaryItems.isEmpty)
        XCTAssertTrue(store.foundNoProblems)
    }
}
