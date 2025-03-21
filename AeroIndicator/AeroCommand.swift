import AppKit
import Foundation

private let aerospaceGetAllWorkspaceCommand = "aerospace list-workspaces --all"
private let aerospaceGetFocusWorkspaceCommand = "aerospace list-workspaces --focused"
private let aerospaceGetAllAppsCommand =
    "aerospace list-windows --all --format \"%{workspace}|||%{app-bundle-id}|||%{app-name}\""

private let yabaiGetAllWorkspacesCommand = "yabai -m query --spaces"
private let yabaiGetAllAppsCommand = "yabai -m query --windows"

private func getBundleIdentifier(for pid: pid_t) -> String? {
    let runningApps = NSWorkspace.shared.runningApplications

    if let app = runningApps.first(where: { $0.processIdentifier == pid }) {
        return app.bundleIdentifier
    }

    return nil
}

struct YabaiWorkspace: Codable {
    let index: Int
    let hasFocus: Bool

    enum CodingKeys: String, CodingKey {
        case index
        case hasFocus = "has-focus"
    }
}

struct YabaiApp: Codable {
    let pid: Int32
    let app: String
    let space: Int
}

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

func getAllWorkspaces(source: String) -> [String] {
    if source == "aerospace" {
        let result = runShellCommand(aerospaceGetAllWorkspaceCommand)
        return result.split(separator: "\n").map({ String($0) })
    } else if source == "yabai" {
        let result = runShellCommand(yabaiGetAllWorkspacesCommand)
        guard let jsonData = result.data(using: .utf8) else {
            fatalError("Failed to convert JSON string to data")
        }
        do {
            let decoder = JSONDecoder()
            let json = try decoder.decode([YabaiWorkspace].self, from: jsonData)
            return json.map({ String($0.index) }
            )
        } catch {
            fatalError("Failed to parse JSON: \(error)")
        }
    } else {
        return []
    }
}

func getFocusedWorkspace(source: String) -> String {
    if source == "aerospace" {
        let result = runShellCommand(aerospaceGetFocusWorkspaceCommand)
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    } else if source == "yabai" {
        let result = runShellCommand(yabaiGetAllWorkspacesCommand)
        guard let jsonData = result.data(using: .utf8) else {
            fatalError("Failed to convert JSON string to data")
        }
        do {
            let decoder = JSONDecoder()
            let json = try decoder.decode([YabaiWorkspace].self, from: jsonData)
            return json.filter({ $0.hasFocus }).map({ String($0.index) })
                .first ?? ""
        } catch {
            fatalError("Failed to parse JSON: \(error)")
        }
    } else {
        return ""
    }
}

func getAllApps(source: String) -> [AppDataType] {
    if source == "aerospace" {
        var apps: [AppDataType] = []
        let result = runShellCommand(aerospaceGetAllAppsCommand)
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
    } else if source == "yabai" {
        let result = runShellCommand(yabaiGetAllAppsCommand)
        guard let jsonData = result.data(using: .utf8) else { return [] }
        do {
            let decoder = JSONDecoder()
            let json = try decoder.decode([YabaiApp].self, from: jsonData)
            return json.filter({ $0.pid != ProcessInfo.processInfo.processIdentifier }).map({
                AppDataType(
                    workspaceId: String($0.space),
                    bundleId: getBundleIdentifier(for: $0.pid) ?? "",
                    appName: $0.app)
            })
        } catch {
            fatalError("Failed to parse JSON: \(error)")
        }
    } else {
        return []
    }
}
