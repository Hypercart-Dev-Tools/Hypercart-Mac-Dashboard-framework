import Observation

@Observable @MainActor
public final class DashboardNavigationStore<Route: Hashable & Sendable>
{
    public init(selectedRoute: Route? = nil)
    {
        self.selectedRoute = selectedRoute
    }

    public var selectedRoute: Route?

    public var hasSelection: Bool
    {
        selectedRoute != nil
    }

    public func present(_ route: Route)
    {
        selectedRoute = route
    }

    public func dismiss()
    {
        selectedRoute = nil
    }
}
