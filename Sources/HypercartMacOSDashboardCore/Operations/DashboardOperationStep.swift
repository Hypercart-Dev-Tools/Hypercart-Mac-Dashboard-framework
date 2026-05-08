import Foundation

public struct DashboardOperationStep<ID: Hashable & Sendable>: Identifiable, Hashable, Sendable
{
    public let id: ID
    public var title: String
    public var isEnabled: Bool

    public init(id: ID, title: String, isEnabled: Bool = true)
    {
        self.id = id
        self.title = title
        self.isEnabled = isEnabled
    }
}
