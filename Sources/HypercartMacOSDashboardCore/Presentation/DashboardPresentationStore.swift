import Observation

@Observable @MainActor
public final class DashboardPresentationStore<Route: Hashable & Sendable, Sheet: Hashable & Sendable, Confirmation: Hashable & Sendable>
{
    public init() {}

    public var navigation: DashboardNavigationStore<Route> = .init()

    public var searchQuery: String = ""
    public var isSearchFieldFocused: Bool = false

    public var activeAlert: DashboardAlertState?
    public var activeSheet: DashboardSheetState<Sheet>?
    public var activeConfirmation: DashboardConfirmationState<Confirmation>?

    public var isShowingBlockingProgress: Bool = false
    public var inlineErrorMessage: String?

    public func showAlert(_ alert: DashboardAlertState)
    {
        activeAlert = alert
    }

    public func dismissAlert()
    {
        activeAlert = nil
    }

    public func showSheet(_ sheet: DashboardSheetState<Sheet>)
    {
        activeSheet = sheet
    }

    public func dismissSheet()
    {
        activeSheet = nil
    }

    public func showConfirmation(_ confirmation: DashboardConfirmationState<Confirmation>)
    {
        activeConfirmation = confirmation
    }

    public func dismissConfirmation()
    {
        activeConfirmation = nil
    }
}
