import SwiftUI

class AppManager: ObservableObject {
    private var show = false
    private var window: MainWindow<AeroIndicatorApp>?
    private var server: Socket?

    @Published var workspaces: [String] = []
    @Published var focusWorkspace: String = ""
    @Published var allApps: [AppDataType] = []

    var isUpdatingApps = false

    func start() {
        Task {
            let workspace = getAllWorksapce()
            let focusWorkspace = getFocusWorksapce()
            let allApps = getAllApps()

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
        let contentRect = NSRect(x: 20, y: 20, width: 1200, height: 40)

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
            if splitMessages[0] == "workspace-change" && splitMessages.count == 2 {
                withAnimation {
                    self.focusWorkspace = splitMessages[1]
                }
            } else if splitMessages[0] == "focus-change" {
                self.getAllWorkspaceApps()
            }
        }
        server?.startListening()
    }
    
    private func getAllWorkspaceApps() {
        if self.isUpdatingApps { return }
        Task {
            self.isUpdatingApps = true
            let allApps = getAllApps()
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
