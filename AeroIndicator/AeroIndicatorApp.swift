import SwiftUI

struct AeroIndicatorApp: View {
    @ObservedObject var model: AppManager

    var body: some View {
        HStack {
            HStack(spacing: 0) {
                if !model.workspaces.isEmpty {
                    ForEach(model.workspaces, id: \.self) { workspace in
                        AeroIndicatorWorkspace(
                            workspace: workspace,
                            model: model
                        )
                    }
                }
            }
            .padding(12)
            .visualEffect(material: .popover, blendingMode: .behindWindow)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            Spacer()
        }
    }
}

struct AeroIndicatorWorkspace: View {
    var workspace: String
    @ObservedObject var model: AppManager
    @State var apps: [AppDataType] = []

    var body: some View {
        HStack(spacing: 0) {
            if workspace == model.focusWorkspace
                || !apps.isEmpty {
                HStack {
                    Text(workspace)
                        .monospaced()
                        .foregroundStyle(
                            model.focusWorkspace == workspace ? Color.red : Color.primary
                        )
                    ForEach(apps, id: \.bundleId) { app in
                        AeroIndicatorWorkspaceApp(app: app)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .onChange(of: model.allApps, initial: true) { _, newValue in
            self.apps = newValue.filter({ $0.workspaceId == workspace })
        }
    }
}

struct AeroIndicatorWorkspaceApp: View {
    var app: AppDataType
    var body: some View {
        if let image = AppIcon.shared.get(app.bundleId) {
            Image(nsImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
        }
    }
}
