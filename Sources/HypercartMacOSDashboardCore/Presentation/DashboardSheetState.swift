import Foundation

public struct DashboardSheetState<Payload: Hashable & Sendable>: Identifiable, Hashable, Sendable
{
    public let id: UUID
    public var payload: Payload
    public var showsTitleBar: Bool

    public init(
        id: UUID = UUID(),
        payload: Payload,
        showsTitleBar: Bool = true
    ) {
        self.id = id
        self.payload = payload
        self.showsTitleBar = showsTitleBar
    }
}
