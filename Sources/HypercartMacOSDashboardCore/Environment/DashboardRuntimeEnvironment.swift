import Foundation
import OSLog
@preconcurrency import UserNotifications

public struct DashboardRuntimeEnvironment
{
    public var logger: Logger
    public var fileManager: FileManager
    public var userDefaults: UserDefaults

    // Resolved lazily because `UNUserNotificationCenter.current()` asserts
    // that `mainBundle.bundleURL` is non-nil. That assumption breaks in
    // hosts without a proper app bundle (SwiftPM-built executables, certain
    // test harnesses), so deferring the call to first access lets consumers
    // that never touch notifications construct the environment safely.
    public lazy var notificationCenter: UNUserNotificationCenter = .current()

    public init(
        logger: Logger,
        fileManager: FileManager = .default,
        userDefaults: UserDefaults = .standard,
        notificationCenter: UNUserNotificationCenter? = nil
    ) {
        self.logger = logger
        self.fileManager = fileManager
        self.userDefaults = userDefaults
        if let notificationCenter
        {
            self.notificationCenter = notificationCenter
        }
    }
}
