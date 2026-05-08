import SwiftUI

public struct DashboardOperationStatusCard<Content: View>: View
{
    private let systemImage: String
    private let title: String
    private let content: Content

    public init(
        systemImage: String,
        title: String,
        @ViewBuilder content: () -> Content
    ) {
        self.systemImage = systemImage
        self.title = title
        self.content = content()
    }

    public var body: some View
    {
        HStack(alignment: .top, spacing: 12)
        {
            Image(systemName: systemImage)
                .resizable()
                .frame(width: 36, height: 36)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 6)
            {
                Text(title)
                    .font(.headline)

                content
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.secondary.opacity(0.08))
        )
    }
}
