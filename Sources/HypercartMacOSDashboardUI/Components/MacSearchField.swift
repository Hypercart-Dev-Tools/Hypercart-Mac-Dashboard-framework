import AppKit
import SwiftUI

public struct MacSearchField: NSViewRepresentable
{
    public final class Coordinator: NSObject, NSSearchFieldDelegate
    {
        var parent: MacSearchField

        init(_ parent: MacSearchField)
        {
            self.parent = parent
        }

        public func controlTextDidChange(_ notification: Notification)
        {
            guard let searchField = notification.object as? NSSearchField
            else
            {
                return
            }

            parent.text = searchField.stringValue
        }
    }

    @Binding private var text: String
    private let prompt: String?

    public init(text: Binding<String>, prompt: String? = nil)
    {
        self._text = text
        self.prompt = prompt
    }

    public func makeNSView(context _: Context) -> NSSearchField
    {
        let searchField = NSSearchField(frame: .zero)
        searchField.placeholderString = prompt
        return searchField
    }

    public func updateNSView(_ searchField: NSSearchField, context: Context)
    {
        searchField.stringValue = text
        searchField.delegate = context.coordinator
    }

    public func makeCoordinator() -> Coordinator
    {
        Coordinator(self)
    }
}
