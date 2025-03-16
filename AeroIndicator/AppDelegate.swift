import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private let appManager = AppManager()
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        appManager.start()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}
