import SwiftUI

public struct LoadingRow: View
{
    private let title: String

    public init(title: String = "Loading…")
    {
        self.title = title
    }

    public var body: some View
    {
        HStack
        {
            ProgressView()
                .scaleEffect(0.6)
            Text(title)
        }
        .foregroundStyle(.secondary)
    }
}
