import Foundation
import OSLog
@preconcurrency import UserNotifications

public struct DashboardRuntimeEnvironment
{
    public var logger: Logger
    public var fileManager: FileManager
    public var userDefaults: UserDefaults
    public var notificationCenter: UNUserNotificationCenter

    public init(
        logger: Logger,
        fileManager: FileManager = .default,
        userDefaults: UserDefaults = .standard,
        notificationCenter: UNUserNotificationCenter = .current()
    ) {
        self.logger = logger
        self.fileManager = fileManager
        self.userDefaults = userDefaults
        self.notificationCenter = notificationCenter
    }
}
