import SwiftUI

/// Bridge AppKit's NSVisualEffectView into SwiftUI
struct VisualEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode
    var state: NSVisualEffectView.State = .active
    var emphasized: Bool = true

    func makeNSView(context: Context) -> NSVisualEffectView {
        context.coordinator.visualEffectView
    }

    func updateNSView(_ view: NSVisualEffectView, context: Context) {
        context.coordinator.update(
            material: material,
            blendingMode: blendingMode,
            state: state,
            emphasized: emphasized
        )
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        let visualEffectView = NSVisualEffectView()

        init() {
            visualEffectView.autoresizesSubviews = true
        }

        func update(
            material: NSVisualEffectView.Material,
            blendingMode: NSVisualEffectView.BlendingMode,
            state: NSVisualEffectView.State,
            emphasized: Bool
        ) {
            visualEffectView.material = material
            visualEffectView.state = state
            visualEffectView.blendingMode = blendingMode
            visualEffectView.isEmphasized = emphasized
        }
    }
}

extension View {
    func visualEffect(
        material: NSVisualEffectView.Material,
        blendingMode: NSVisualEffectView.BlendingMode,
        state: NSVisualEffectView.State = .active,
        emphasized: Bool = true
    ) -> some View {
        self.background(
            VisualEffectView(
                material: material, blendingMode: blendingMode, state: state, emphasized: emphasized
            ))
    }
}
