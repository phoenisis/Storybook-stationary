import SwiftUI

struct StorybookShowcaseData {
    static let colors: [ShowcaseColorToken] = [
        .init(name: "appPrimary", color: .appPrimary, text: .white),
        .init(name: "appPrimaryDim", color: .appPrimaryDim, text: .white),
        .init(name: "appPrimaryContainer", color: .appPrimaryContainer, text: .appOnPrimaryContainer),
        .init(name: "appSecondary", color: .appSecondary, text: .white),
        .init(name: "appSecondaryDim", color: .appSecondaryDim, text: .white),
        .init(name: "appSecondaryContainer", color: .appSecondaryContainer, text: .appOnSecondaryContainer),
        .init(name: "tertiary", color: .tertiary, text: .white),
        .init(name: "tertiaryContainer", color: .tertiaryContainer, text: .onTertiaryContainer),
        .init(name: "background", color: .background, text: .onSurface),
        .init(name: "surface", color: .surface, text: .onSurface),
        .init(name: "surfaceLow", color: .surfaceLow, text: .onSurface),
        .init(name: "surfaceHigh", color: .surfaceHigh, text: .onSurface),
        .init(name: "outline", color: .outline, text: .white),
        .init(name: "outlineVariant", color: .outlineVariant, text: .onSurface)
    ]

    static let gradients: [ShowcaseGradientToken] = [
        .init(name: "paperSurfaceFade", gradient: .paperSurfaceFade),
        .init(name: "primarySticker", gradient: .primarySticker),
        .init(name: "tertiarySticker", gradient: .tertiarySticker)
    ]

    static let fonts: [ShowcaseFontToken] = [
        .init(name: "appTitle", font: .appTitle),
        .init(name: "sectionTitle", font: .sectionTitle),
        .init(name: "displayHero", font: .displayHero),
        .init(name: "headingL", font: .headingL),
        .init(name: "metricValue", font: .metricValue),
        .init(name: "bodyM", font: .bodyM),
        .init(name: "bodyS", font: .bodyS),
        .init(name: "labelM", font: .labelM),
        .init(name: "labelS", font: .labelS)
    ]

    static let spacingTokens: [ShowcaseScalarToken] = [
        .init(name: "xxs", value: .xxs),
        .init(name: "xs", value: .xs),
        .init(name: "s", value: .s),
        .init(name: "m", value: .m),
        .init(name: "l", value: .l),
        .init(name: "xl", value: .xl),
        .init(name: "xxl", value: .xxl),
        .init(name: "xxxl", value: .xxxl),
        .init(name: "jumbo", value: .jumbo)
    ]

    static let sizeTokens: [ShowcaseScalarToken] = [
        .init(name: "grainDot", value: .grainDot),
        .init(name: "dot", value: .dot),
        .init(name: "spiralGap", value: .spiralGap),
        .init(name: "spiralSpineWidth", value: .spiralSpineWidth),
        .init(name: "avatar", value: .avatar),
        .init(name: "iconButton", value: .iconButton),
        .init(name: "badge", value: .badge),
        .init(name: "swatchHeight", value: .swatchHeight),
        .init(name: "progressRowHeight", value: .progressRowHeight),
        .init(name: "sliderTrackHeight", value: .sliderTrackHeight),
        .init(name: "displayHero", value: .displayHero),
        .init(name: "metricValue", value: .metricValue)
    ]

    static let radiusTokens: [ShowcaseScalarToken] = [
        .init(name: "cornerS", value: .cornerS),
        .init(name: "cornerM", value: .cornerM),
        .init(name: "cornerL", value: .cornerL),
        .init(name: "cornerXL", value: .cornerXL),
        .init(name: "cornerXXL", value: .cornerXXL),
        .init(name: "cornerXXXL", value: .cornerXXXL),
        .init(name: "cornerPill", value: .cornerPill),
        .init(name: "cornerDrawer", value: .cornerDrawer)
    ]

    static let strokeTokens: [ShowcaseScalarToken] = [
        .init(name: "lineHairline", value: .lineHairline),
        .init(name: "lineS", value: .lineS),
        .init(name: "lineM", value: .lineM)
    ]

    static let metricTokens: [ShowcaseScalarToken] = [
        .init(name: "trackTight", value: .trackTight),
        .init(name: "trackDisplay", value: .trackDisplay),
        .init(name: "trackHeading", value: .trackHeading),
        .init(name: "trackCompact", value: .trackCompact),
        .init(name: "trackMetric", value: .trackMetric),
        .init(name: "appLineSpacing", value: .appLineSpacing),
        .init(name: "stickerRotation", value: .stickerRotation)
    ]
}

struct ShowcaseColorToken: Identifiable {
    let name: String
    let color: Color
    let text: Color

    var id: String { name }
}

struct ShowcaseGradientToken: Identifiable {
    let name: String
    let gradient: LinearGradient

    var id: String { name }
}

struct ShowcaseFontToken: Identifiable {
    let name: String
    let font: Font

    var id: String { name }
}

struct ShowcaseScalarToken: Identifiable {
    let name: String
    let value: CGFloat

    var id: String { name }
}

extension Double {
    var showcaseDecimal: String {
        String(format: "%.2f", self)
    }
}

extension CGFloat {
    var showcaseDecimal: String {
        Double(self).showcaseDecimal
    }
}
