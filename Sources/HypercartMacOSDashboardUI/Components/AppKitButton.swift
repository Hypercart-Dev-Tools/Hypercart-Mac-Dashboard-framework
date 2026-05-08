import AppKit
import SwiftUI

public struct AppKitButton: NSViewRepresentable
{
    public typealias NSViewType = NSButton

    public final class Coordinator: NSObject
    {
        var parent: AppKitButton

        init(_ parent: AppKitButton)
        {
            self.parent = parent
        }

        @MainActor @objc func buttonClicked(_: Any?)
        {
            parent.action()
        }
    }

    private let title: String
    private let style: NSButton.BezelStyle
    private let action: () -> Void

    public init(
        title: String,
        style: NSButton.BezelStyle = .push,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.action = action
    }

    public func makeNSView(context: Context) -> NSButton
    {
        let button = NSButton()

        if style == .disclosure || style == .pushDisclosure
        {
            button.setButtonType(.pushOnPushOff)
        }

        button.bezelStyle = style
        button.target = context.coordinator
        button.action = #selector(Coordinator.buttonClicked)
        button.title = title

        return button
    }

    public func updateNSView(_ nsView: NSButton, context _: Context)
    {
        nsView.title = title
        nsView.bezelStyle = style
    }

    public func makeCoordinator() -> Coordinator
    {
        Coordinator(self)
    }
}
