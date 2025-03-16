import SwiftUI

extension NSColor {
    static func fromHex(_ hexString: String?) -> NSColor? {
        guard let hexString = hexString else { return nil }
        var hex = hexString
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }

        guard hex.count == 6 || hex.count == 8 else {
            return nil
        }

        var hexInt: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&hexInt)
        var red: Double = 0.0
        var green: Double = 0.0
        var blue: Double = 0.0
        var alpha: Double = 1.0

        if hex.count == 8 {
            red = Double((hexInt & 0xff00_0000) >> 24) / 255.0
            green = Double((hexInt & 0x00ff_0000) >> 16) / 255.0
            blue = Double((hexInt & 0x0000_ff00) >> 8) / 255.0
            alpha = Double(hexInt & 0x0000_00ff) / 255.0
        } else {
            red = Double((hexInt & 0xff0000) >> 16) / 255.0
            green = Double((hexInt & 0x00ff00) >> 8) / 255.0
            blue = Double(hexInt & 0x0000ff) / 255.0
        }

        return NSColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension Color {
    static func dynamic(_ light: NSColor, dark: NSColor? = nil) -> Color {
        Color(nsColor: NSColor(name: nil, dynamicProvider: { appearance in
            if appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua {
                return dark ?? light
            } else {
                return light
            }
        }))
    }
}
