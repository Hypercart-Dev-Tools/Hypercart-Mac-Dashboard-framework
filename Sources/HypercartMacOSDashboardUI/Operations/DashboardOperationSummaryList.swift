import SwiftUI
import HypercartMacOSDashboardCore

public struct DashboardOperationSummaryList: View
{
    private let items: [DashboardOperationSummaryItem]

    public init(items: [DashboardOperationSummaryItem])
    {
        self.items = items
    }

    public var body: some View
    {
        VStack(alignment: .leading, spacing: 10)
        {
            ForEach(items) { item in
                VStack(alignment: .leading, spacing: 4)
                {
                    Text(item.title)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if let detail = item.detail
                    {
                        Text(detail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }
}
