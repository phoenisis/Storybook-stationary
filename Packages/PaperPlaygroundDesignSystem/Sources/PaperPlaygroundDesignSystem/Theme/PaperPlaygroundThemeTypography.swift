import SwiftUI

/// Thematic namespace for Paper Playground style primitives.
public enum PaperPlaygroundTheme {
    /// Typography tokens used across components and feature screens.
    public enum Typography {
        public static let appTitle = Font.custom("Plus Jakarta Sans", size: 26, relativeTo: .title)
        public static let sectionTitle = Font.custom("Plus Jakarta Sans", size: 28, relativeTo: .title)
        public static let displayHero = Font.custom("Plus Jakarta Sans", size: .displayHero, relativeTo: .largeTitle)
        public static let headingL = Font.custom("Plus Jakarta Sans", size: 27, relativeTo: .title2)
        public static let metricValue = Font.custom("Plus Jakarta Sans", size: .metricValue, relativeTo: .largeTitle)
        public static let bodyM = Font.custom("Lexend", size: 16, relativeTo: .body)
        public static let bodyS = Font.custom("Lexend", size: 13, relativeTo: .subheadline)
        public static let labelM = Font.custom("Lexend", size: 11, relativeTo: .caption)
        public static let labelS = Font.custom("Lexend", size: 10, relativeTo: .caption2)
    }
}

/// Font aliases that expose Paper Playground typography tokens directly on `Font`.
public extension Font {
    static let appTitle = PaperPlaygroundTheme.Typography.appTitle
    static let sectionTitle = PaperPlaygroundTheme.Typography.sectionTitle
    static let displayHero = PaperPlaygroundTheme.Typography.displayHero
    static let headingL = PaperPlaygroundTheme.Typography.headingL
    static let metricValue = PaperPlaygroundTheme.Typography.metricValue
    static let bodyM = PaperPlaygroundTheme.Typography.bodyM
    static let bodyS = PaperPlaygroundTheme.Typography.bodyS
    static let labelM = PaperPlaygroundTheme.Typography.labelM
    static let labelS = PaperPlaygroundTheme.Typography.labelS
}
