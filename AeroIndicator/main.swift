import Cocoa
import Foundation

func isAppAlreadyRunning() -> Bool {
    let fileManager = FileManager.default
    return fileManager.fileExists(atPath: "/tmp/AeroIndicator")
}

func startApplication() {
    let delegate = AppDelegate()
    NSApplication.shared.delegate = delegate
    _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
}

if CommandLine.arguments.count > 1 {
    let message = CommandLine.arguments[1...].joined(separator: " ")
    if isAppAlreadyRunning() {
        let client = Socket(isClient: true)
        client.send(message: message)
        exit(0)
    } else {
        print("Error: Application is not running. Run application first.")
        exit(1)
    }
} else {
    if isAppAlreadyRunning() {
        print("Error: Application is already running. Please provide command arguments.")
        exit(1)
    } else {
        startApplication()
    }
}
