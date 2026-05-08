import AppKit
import SwiftUI

public struct IconDetailRow<Content: View>: View
{
    public enum IconSource
    {
        case systemSymbol(String)
        case appKitImageName(NSImage.Name)
        case image(Image)
    }

    private let icon: IconSource
    private let iconSize: CGFloat
    private let content: Content

    public init(
        icon: IconSource,
        iconSize: CGFloat = 50,
        @ViewBuilder content: () -> Content
    ) {
        self.icon = icon
        self.iconSize = iconSize
        self.content = content()
    }

    public var body: some View
    {
        HStack(alignment: .top, spacing: 10)
        {
            renderedIcon
            content
        }
    }

    @ViewBuilder
    private var renderedIcon: some View
    {
        switch icon
        {
        case .systemSymbol(let name):
            Image(systemName: name)
                .resizable()
                .frame(width: iconSize, height: iconSize)
                .foregroundColor(.secondary)
        case .appKitImageName(let name):
            if let image = NSImage(named: name)
            {
                Image(nsImage: image)
                    .resizable()
                    .frame(width: iconSize, height: iconSize)
                    .foregroundColor(.secondary)
            }
        case .image(let image):
            image
                .resizable()
                .frame(width: iconSize, height: iconSize)
                .foregroundColor(.secondary)
        }
    }
}
