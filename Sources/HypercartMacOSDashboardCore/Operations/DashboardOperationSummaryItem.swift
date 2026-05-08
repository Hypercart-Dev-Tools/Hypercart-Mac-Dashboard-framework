import Foundation

public struct DashboardOperationSummaryItem: Identifiable, Hashable, Sendable
{
    public let id: UUID
    public var title: String
    public var detail: String?

    public init(id: UUID = UUID(), title: String, detail: String? = nil)
    {
        self.id = id
        self.title = title
        self.detail = detail
    }
}
