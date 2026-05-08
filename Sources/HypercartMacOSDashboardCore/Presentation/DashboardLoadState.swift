public enum DashboardLoadState<Value>
{
    case idle
    case loading
    case loaded(Value)
    case failed(message: String)
}

public extension DashboardLoadState
{
    var isLoading: Bool
    {
        if case .loading = self
        {
            return true
        }
        else
        {
            return false
        }
    }
}
