import SwiftUI

class AppIcon {
    static let shared = AppIcon()
    
    private var map: [String: NSImage] = [:]
    
    func get(_ bundleID: String) -> NSImage? {
        if let image = map[bundleID] {
            return image
        }
        let workspace = NSWorkspace.shared
        if let appURL = workspace.urlForApplication(withBundleIdentifier: bundleID) {
            let image = workspace.icon(forFile: appURL.path)
            map[bundleID] = image
            return image
        }
        return nil
    }
}
