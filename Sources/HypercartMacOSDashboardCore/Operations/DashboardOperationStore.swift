import Observation

@Observable @MainActor
public final class DashboardOperationStore<StepID: Hashable & Sendable>
{
    public init(
        phase: DashboardOperationPhase = .ready,
        configuredSteps: [DashboardOperationStep<StepID>] = []
    ) {
        self.phase = phase
        self.configuredSteps = configuredSteps
    }

    public var phase: DashboardOperationPhase
    public var configuredSteps: [DashboardOperationStep<StepID>]
    public var currentStepTitle: String = "Waiting"
    public var summaryItems: [DashboardOperationSummaryItem] = []
    public var foundNoProblems: Bool = true

    public var enabledStepCount: Int
    {
        configuredSteps.filter(\.isEnabled).count
    }

    public var canStart: Bool
    {
        enabledStepCount > 0 && phase == .ready
    }

    public func updateStep(id: StepID, isEnabled: Bool)
    {
        guard let index = configuredSteps.firstIndex(where: { $0.id == id }) else
        {
            return
        }

        configuredSteps[index].isEnabled = isEnabled
    }

    public func begin(withTitle title: String = "Working…")
    {
        phase = .running
        currentStepTitle = title
        summaryItems = []
        foundNoProblems = true
    }

    public func updateCurrentStep(title: String)
    {
        currentStepTitle = title
    }

    public func finish(summaryItems: [DashboardOperationSummaryItem], foundNoProblems: Bool = true)
    {
        phase = .finished
        self.summaryItems = summaryItems
        self.foundNoProblems = foundNoProblems
    }

    public func reset()
    {
        phase = .ready
        currentStepTitle = "Waiting"
        summaryItems = []
        foundNoProblems = true
    }
}
