import SwiftUI

public struct DashboardOperationProgressPanel: View
{
    private let title: String

    public init(title: String)
    {
        self.title = title
    }

    public var body: some View
    {
        VStack(spacing: 12)
        {
            ProgressView()
                .controlSize(.regular)

            Text(title)
                .font(.body.weight(.medium))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 180)
    }
}
