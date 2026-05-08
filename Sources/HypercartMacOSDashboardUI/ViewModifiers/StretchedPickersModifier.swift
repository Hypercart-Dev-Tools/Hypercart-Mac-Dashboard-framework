import SwiftUI

public struct StretchedPickersModifier: ViewModifier
{
    public init() {}

    public func body(content: Content) -> some View
    {
        if #available(macOS 26, *)
        {
            content.buttonSizing(.flexible)
        }
        else
        {
            content
        }
    }
}

public extension View
{
    func stretchedPickers() -> some View
    {
        modifier(StretchedPickersModifier())
    }
}
