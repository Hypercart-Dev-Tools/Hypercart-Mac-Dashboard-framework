import SwiftUI

public struct InlineContentUnavailableRow: View
{
    private let label: String
    private let systemImage: String

    public init(label: String, systemImage: String)
    {
        self.label = label
        self.systemImage = systemImage
    }

    public var body: some View
    {
        HStack(alignment: .center, spacing: 6)
        {
            Image(systemName: systemImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20)
                .foregroundStyle(.tertiary)

            Text(label)
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }
}
