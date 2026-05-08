import SwiftUI

public struct SheetContainer<Content: View>: View
{
    private let showsTitleBar: Bool
    private let minimumWidth: CGFloat
    private let content: Content

    public init(
        showsTitleBar: Bool = true,
        minimumWidth: CGFloat = 300,
        @ViewBuilder content: () -> Content
    ) {
        self.showsTitleBar = showsTitleBar
        self.minimumWidth = minimumWidth
        self.content = content()
    }

    public var body: some View
    {
        content
            .toolbar(.hidden, for: showsTitleBar ? .automatic : .windowToolbar)
            .padding()
            .frame(minWidth: minimumWidth)
    }
}
