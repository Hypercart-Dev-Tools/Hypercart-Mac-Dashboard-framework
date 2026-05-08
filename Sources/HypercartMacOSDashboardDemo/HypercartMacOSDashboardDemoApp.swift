import SwiftUI

@main
struct HypercartMacOSDashboardDemoApp: App
{
    var body: some Scene
    {
        WindowGroup
        {
            DashboardDemoRootView()
        }
        .windowResizability(.contentSize)
    }
}
