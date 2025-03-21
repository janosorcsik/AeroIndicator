import Foundation
import Toml

func readConfigFile() -> String? {
    let fileManager = FileManager.default
    let homeDirectory = fileManager.homeDirectoryForCurrentUser.path
    let configPath = "\(homeDirectory)/.config/aeroIndicator/config.toml"
    let path = URL(fileURLWithPath: configPath)
    do {
        let content = try String(contentsOf: path, encoding: .utf8)
        return content
    } catch {
        print("Error reading config file: \(error)")
        return nil
    }
}

let defaultConfig = AeroConfig(
    source: "aerospace",
    position: "bottom-left",
    outerPadding: 20,
    innerPadding: 12,
    borderRadius: 12
)

func readConfig() -> AeroConfig {
    guard let configString = readConfigFile() else { return defaultConfig }
    let config = try? Toml(withString: configString)

    let source = config?.string("source") ?? defaultConfig.source
    let position = config?.string("position") ?? defaultConfig.position
    let outerPadding = config?.double("outer-padding") ?? defaultConfig.outerPadding
    let innerPadding = config?.double("inner-padding") ?? defaultConfig.innerPadding
    let borderRadius = config?.double("border-radius") ?? defaultConfig.borderRadius
    return AeroConfig(
        source: source,
        position: position,
        outerPadding: outerPadding,
        innerPadding: innerPadding,
        borderRadius: borderRadius
    )
}

struct AeroConfig {
    var source: String
    var position: String
    var outerPadding: Double
    var innerPadding: Double
    var borderRadius: Double
}
