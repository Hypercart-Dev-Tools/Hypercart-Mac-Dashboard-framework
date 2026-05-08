import Foundation

public struct DashboardAlertState: Identifiable, Hashable, Sendable
{
    public let id: UUID
    public var title: String
    public var message: String?
    public var recoveryActionTitle: String?

    public init(
        id: UUID = UUID(),
        title: String,
        message: String? = nil,
        recoveryActionTitle: String? = nil
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.recoveryActionTitle = recoveryActionTitle
    }
}
