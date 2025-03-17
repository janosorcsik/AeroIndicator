import Foundation

private let getAllWorkspaceCommand = "aerospace list-workspaces --all"
private let getFocusWorkspaceCommand = "aerospace list-workspaces --focused"
private let getAllAppsCommand =
    "aerospace list-windows --all --format \"%{workspace}|||%{app-bundle-id}|||%{app-name}\""

private func runShellCommand(_ command: String, arguments: [String] = []) -> String {
    let process = Process()
    process.launchPath = "/bin/sh"
    process.arguments = ["-c", "export PATH=\"/opt/homebrew/bin:$PATH\" && \(command)"] + arguments

    let pipe = Pipe()
    process.standardOutput = pipe
    process.standardError = pipe

    do {
        try process.run()
    } catch {
        fatalError("Failed to run process: \(error)")
    }

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    return String(data: data, encoding: .utf8)!.trimmingCharacters(in: .whitespacesAndNewlines)
}

func getAllWorksapce() -> [String] {
    let result = runShellCommand(getAllWorkspaceCommand)
    return result.split(separator: "\n").map({ String($0) })
}

func getFocusWorksapce() -> String {
    return runShellCommand(getFocusWorkspaceCommand)
}

func getAllApps() -> [AppDataType] {
    var apps: [AppDataType] = []
    let result = runShellCommand(getAllAppsCommand)
    for appString in result.split(separator: "\n") {
        let appData = appString.components(separatedBy: "|||")
        guard appData.count == 3 else { continue }
        apps.append(
            AppDataType(
                workspaceId: appData[0],
                bundleId: appData[1],
                appName: appData[2]
            )
        )
    }
    return apps
}
