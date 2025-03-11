import Foundation

let arguments = CommandLine.arguments

if arguments.count > 1 {
    let client = Socket(isClient: true)
    client.send(message: arguments[1...].joined(separator: " "))
}
