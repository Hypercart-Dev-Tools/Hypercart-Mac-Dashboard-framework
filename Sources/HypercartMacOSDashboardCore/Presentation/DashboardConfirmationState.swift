import Foundation

public struct DashboardConfirmationState<Payload: Hashable & Sendable>: Identifiable, Hashable, Sendable
{
    public enum Role: String, Hashable, Sendable
    {
        case `default`
        case destructive
    }

    public let id: UUID
    public var payload: Payload
    public var title: String
    public var message: String?
    public var confirmLabel: String
    public var cancelLabel: String
    public var role: Role

    public init(
        id: UUID = UUID(),
        payload: Payload,
        title: String,
        message: String? = nil,
        confirmLabel: String,
        cancelLabel: String = "Cancel",
        role: Role = .default
    ) {
        self.id = id
        self.payload = payload
        self.title = title
        self.message = message
        self.confirmLabel = confirmLabel
        self.cancelLabel = cancelLabel
        self.role = role
    }
}
