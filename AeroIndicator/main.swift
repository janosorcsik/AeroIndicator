import Cocoa
import Foundation

func isAppRunning() -> Bool {
    return FileManager.default.fileExists(atPath: "/tmp/AeroIndicator")
}
func runApp() {
    let delegate = AppDelegate()
    NSApplication.shared.delegate = delegate
    _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
}

let appIsRunning = isAppRunning()
let args = CommandLine.arguments

if args.count == 1 && appIsRunning {
    print("Error: Another instance of AeroIndicator is already running.")
    exit(1)
} else {
    if !appIsRunning {
        runApp()
    }
    if args.count > 1 {
        let client = Socket(isClient: true)
        client.send(message: CommandLine.arguments[1...].joined(separator: " "))
        exit(0)
    }
}
