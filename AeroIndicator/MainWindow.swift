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
                .nonactivatingPanel,
                .fullSizeContentView,
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

        /// Allow the pannel to be overlaid in a fullscreen space
        collectionBehavior.insert(.fullScreenAuxiliary)

        /// Don't show a window title, even if it's set
        titleVisibility = .hidden
        titlebarAppearsTransparent = true

        /// Since there is no title bar make the window moveable by dragging on the background
        isMovableByWindowBackground = true

        /// Hide when unfocused
        hidesOnDeactivate = false

        /// Hide all traffic light buttons
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true

        /// Sets animations accordingly
        animationBehavior = .default

        /// Set the content view.
        /// The safe area is ignored because the title bar still interferes with the geometry
        contentView = NSHostingView(
            rootView: view()
                .ignoresSafeArea())
    }
}
