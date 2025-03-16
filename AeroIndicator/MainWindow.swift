import SwiftUI

class MainWindow<Content: View>: NSPanel {
    init(
        contentRect: NSRect,
        view: () -> Content
    ) {
        /// Init the window as usual
        super.init(
            contentRect: contentRect,
            styleMask: [
                .nonactivatingPanel
            ],
            backing: .buffered,
            defer: true
        )

        /// Allow the panel to be on top of other windows
        isFloatingPanel = true
        level = .floating
        isOpaque = true

        backgroundColor = .clear
        hasShadow = true

        /// Sets animations accordingly
        animationBehavior = .utilityWindow

        /// Set the content view.
        contentView = NSHostingView(rootView: view())
    }
}
