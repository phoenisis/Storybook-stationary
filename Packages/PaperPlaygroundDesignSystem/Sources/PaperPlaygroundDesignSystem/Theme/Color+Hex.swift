import SwiftUI

extension Color {
    init(paperPlaygroundHex: UInt32, alpha: Double = 1) {
        let red = Double((paperPlaygroundHex >> 16) & 0xFF) / 255
        let green = Double((paperPlaygroundHex >> 8) & 0xFF) / 255
        let blue = Double(paperPlaygroundHex & 0xFF) / 255
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}
