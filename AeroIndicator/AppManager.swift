import SwiftUI

class AppManager: ObservableObject {
    private var show = false
    private var window: MainWindow<AeroIndicatorApp>?
    private var server: Socket?

    @Published var workspaces: [String] = []
    @Published var focusWorkspace: String = ""
    @Published var allApps: [AppDataType] = []
    @Published var config: AeroConfig = readConfig()

    var isUpdatingApps = false

    func start() {
        Task {
            let workspace = getAllWorkspaces(source: config.source)
            let focusWorkspace = getFocusedWorkspace(source: config.source)
            let allApps = getAllApps(source: config.source)
            
            print(workspace)

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.workspaces = workspace
                self.focusWorkspace = focusWorkspace
                self.allApps = allApps

                self.createWindow()
            }
        }
        startListeningKey()
        startListeningCommand()
    }

    private func createWindow() {
        guard let screenFrame = NSScreen.main?.frame else { return }
        let statusBarHeight = NSStatusBar.system.thickness
        print("frame \(screenFrame), height: \(statusBarHeight)")
        let contentRect = NSRect(
            x: 0,
            y: 0,
            width: screenFrame.size.width,
            height: screenFrame.size.height - statusBarHeight
        )

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.window = MainWindow(contentRect: contentRect) {
                AeroIndicatorApp(model: self)
            }

            self.window?.orderOut(nil)
        }
    }

    private func startListeningCommand() {
        server = Socket(isClient: false) { message in
            let splitMessages = message.split(separator: " ").map({ String($0) })
            guard splitMessages.count > 0 else { return }
            print(splitMessages)
            if splitMessages[0] == "workspace-change" && splitMessages.count == 2 {
                withAnimation {
                    self.focusWorkspace = splitMessages[1]
                }
                print("workspace change")
            } else if splitMessages[0] == "focus-change" {
                self.getAllWorkspaceApps()
            } else if splitMessages[0] == "workspace-created-or-destroyed" {
                self.workspaces = getAllWorkspaces(source: self.config.source)
            }
        }
        server?.startListening()
    }

    private func getAllWorkspaceApps() {
        if self.isUpdatingApps { return }
        Task {
            self.isUpdatingApps = true
            let allApps = getAllApps(source: config.source)
            DispatchQueue.main.async {
                self.allApps = allApps
                self.isUpdatingApps = false
            }
        }
    }

    private func startListeningKey() {
        func handleEvent(_ event: NSEvent) {
            if event.modifierFlags.contains(.option) {
                self.show = true
                DispatchQueue.main.async {
                    self.window?.orderFrontRegardless()
                }
            } else if self.show {
                self.show = false
                DispatchQueue.main.async {
                    self.window?.orderOut(nil)
                }
            }
        }
        NSEvent.addGlobalMonitorForEvents(
            matching: [.flagsChanged],
            handler: { event in
                handleEvent(event)
            })

        NSEvent.addLocalMonitorForEvents(
            matching: [.flagsChanged],
            handler: { event in
                handleEvent(event)
                return nil
            })
    }
}
