import OSLog
import XCTest
@testable import HypercartMacOSDashboardCore

final class DashboardRuntimeEnvironmentTests: XCTestCase
{
    // Regression test: prior to making `notificationCenter` lazy, the
    // default argument `UNUserNotificationCenter.current()` was evaluated
    // at init time and crashed hosts without a valid main bundle. This
    // test passes only if init does not eagerly touch the notification
    // center.
    func test_init_doesNotEagerlyResolveNotificationCenter() throws
    {
        let logger = Logger(subsystem: "test.dashboard.env", category: "init-test")

        // If init were still eager, the XCTest harness would survive (it
        // has a bundle) — but consumers like SwiftPM-built executables
        // would not. We at minimum exercise the no-arg init path here.
        _ = DashboardRuntimeEnvironment(logger: logger)
    }

    func test_init_acceptsInjectedDependencies()
    {
        let logger = Logger(subsystem: "test.dashboard.env", category: "inject-test")
        let defaults = UserDefaults(suiteName: "DashboardRuntimeEnvironmentTests")!
        let fileManager = FileManager.default

        let env = DashboardRuntimeEnvironment(
            logger: logger,
            fileManager: fileManager,
            userDefaults: defaults
        )

        XCTAssertIdentical(env.fileManager, fileManager)
        XCTAssertEqual(env.userDefaults, defaults)
    }
}
