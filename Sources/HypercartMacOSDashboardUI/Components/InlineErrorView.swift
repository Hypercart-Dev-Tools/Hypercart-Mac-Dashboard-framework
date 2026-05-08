import SwiftUI

public struct InlineErrorView: View
{
    private let title: String
    private let message: String?
    private let retryTitle: String?
    private let retryAction: (() -> Void)?

    public init(
        title: String,
        message: String? = nil,
        retryTitle: String? = nil,
        retryAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.retryTitle = retryTitle
        self.retryAction = retryAction
    }

    public var body: some View
    {
        Group
        {
            if #available(macOS 14.0, *)
            {
                ContentUnavailableView(
                    title,
                    systemImage: "exclamationmark.triangle.fill",
                    description: message.map(Text.init)
                )
            }
            else
            {
                VStack(alignment: .center, spacing: 10)
                {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)

                    Text(title)
                        .multilineTextAlignment(.center)

                    if let message
                    {
                        Text(message)
                            .multilineTextAlignment(.center)
                    }

                    if let retryTitle, let retryAction
                    {
                        Button(retryTitle, action: retryAction)
                    }
                }
                .foregroundColor(.gray)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}
