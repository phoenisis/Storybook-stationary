import SwiftUI

/// Raw Paper Playground color palette definitions.
public extension Color {
    /// Base palette namespace.
    enum PaperPlayground {
        public static let primary = Color(paperPlaygroundHex: 0x006289)
        public static let primaryDim = Color(paperPlaygroundHex: 0x00425E)
        public static let primaryContainer = Color(paperPlaygroundHex: 0x64BFF5)
        public static let onPrimaryContainer = Color(paperPlaygroundHex: 0x003951)

        public static let secondary = Color(paperPlaygroundHex: 0x705900)
        public static let secondaryDim = Color(paperPlaygroundHex: 0x5C4900)
        public static let secondaryContainer = Color(paperPlaygroundHex: 0xFDD34D)
        public static let onSecondaryContainer = Color(paperPlaygroundHex: 0x5C4900)

        public static let tertiary = Color(paperPlaygroundHex: 0x0D684A)
        public static let tertiaryDim = Color(paperPlaygroundHex: 0x056547)
        public static let tertiaryContainer = Color(paperPlaygroundHex: 0xADFFD7)
        public static let onTertiaryContainer = Color(paperPlaygroundHex: 0x056547)

        public static let background = Color(paperPlaygroundHex: 0xF7F6F3)
        public static let surface = Color(paperPlaygroundHex: 0xFFFFFF)
        public static let surfaceLow = Color(paperPlaygroundHex: 0xF1F1EE)
        public static let surfaceHigh = Color(paperPlaygroundHex: 0xDDDDD9)

        public static let onSurface = Color(paperPlaygroundHex: 0x2E2F2D)
        public static let onSurfaceVariant = Color(paperPlaygroundHex: 0x5B5C5A)
        public static let outline = Color(paperPlaygroundHex: 0x767775)
        public static let outlineVariant = Color(paperPlaygroundHex: 0xADADAB)
    }
}
