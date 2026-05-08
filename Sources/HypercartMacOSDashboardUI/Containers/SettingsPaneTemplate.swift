import SwiftUI

public struct SettingsPaneTemplate<Content: View>: View
{
    private let minimumWidth: CGFloat
    private let minimumHeight: CGFloat
    private let content: Content

    public init(
        minimumWidth: CGFloat = 470,
        minimumHeight: CGFloat = 50,
        @ViewBuilder content: () -> Content
    ) {
        self.minimumWidth = minimumWidth
        self.minimumHeight = minimumHeight
        self.content = content()
    }

    public var body: some View
    {
        content
            .stretchedPickers()
            .labeledContentStyle(.automatic)
            .frame(minWidth: minimumWidth, minHeight: minimumHeight)
            .fixedSize()
            .modifier(AdaptivePanePaddingModifier())
    }
}

private struct AdaptivePanePaddingModifier: ViewModifier
{
    func body(content: Content) -> some View
    {
        if #available(macOS 15, *)
        {
            content.scenePadding()
        }
        else
        {
            content.padding()
        }
    }
}
