import CoreGraphics

/// Canonical scalar token namespace for spacing, sizing, radii, strokes, opacity, and effects.
public enum PaperPlaygroundTokens {
    /// Effect and motion-related scalar constants.
    public enum Effect {
        public static let grainCount: Int = 4200
        public static let grainOpacity: CGFloat = 0.08
        public static let springResponse: CGFloat = 0.24
        public static let springDamping: CGFloat = 0.82
        public static let pressSpringResponse: CGFloat = 0.2
        public static let pressSpringDamping: CGFloat = 0.85
    }

    /// Spacing scale used throughout layout and component composition.
    public enum Space {
        public static let xxs: CGFloat = 4
        public static let xs: CGFloat = 6
        public static let s: CGFloat = 8
        public static let m: CGFloat = 10
        public static let l: CGFloat = 12
        public static let xl: CGFloat = 14
        public static let xxl: CGFloat = 16
        public static let xxxl: CGFloat = 18
        public static let jumbo: CGFloat = 28
    }

    /// Size scale used for controls, icons, and component dimensions.
    public enum Size {
        public static let grainDot: CGFloat = 1.1
        public static let dot: CGFloat = 6
        public static let spiralGap: CGFloat = 9
        public static let spiralSpineWidth: CGFloat = 26
        public static let avatar: CGFloat = 34
        public static let iconButton: CGFloat = 44
        public static let badge: CGFloat = 46
        public static let swatchHeight: CGFloat = 66
        public static let progressRowHeight: CGFloat = 34
        public static let sliderTrackHeight: CGFloat = 10
        public static let displayHero: CGFloat = 82
        public static let metricValue: CGFloat = 44
        public static let bottomInset: CGFloat = 140
    }

    /// Corner radius scale for cards, pills, and containers.
    public enum Radius {
        public static let s: CGFloat = 12
        public static let m: CGFloat = 14
        public static let l: CGFloat = 16
        public static let xl: CGFloat = 20
        public static let xxl: CGFloat = 22
        public static let xxxl: CGFloat = 24
        public static let pill: CGFloat = 30
        public static let drawer: CGFloat = 40
    }

    /// Stroke width scale for borders and outlines.
    public enum Stroke {
        public static let hairline: CGFloat = 1
        public static let s: CGFloat = 2
        public static let m: CGFloat = 4
    }

    /// Shared opacity constants for shadows, states, and overlays.
    public enum Opacity {
        public static let shadowLight: Double = 0.05
        public static let shadowMedium: Double = 0.10
        public static let shadowHeavy: Double = 0.12
        public static let progressFilledShadow: Double = 0.15
        public static let progressCurrentShadow: Double = 0.13
        public static let subtle: Double = 0.16
        public static let border: Double = 0.18
        public static let soft: Double = 0.22
        public static let medium: Double = 0.35
        public static let wash: Double = 0.45
        public static let accent: Double = 0.40
        public static let selectedShadow: Double = 0.50
        public static let iconMuted: Double = 0.62
        public static let strong: Double = 0.55
        public static let disabled: Double = 0.66
    }

    /// Miscellaneous typographic and interaction metrics.
    public enum Metric {
        public static let minimumScale: CGFloat = 0.7
        public static let lineSpacing: CGFloat = 4
        public static let trackingTight: CGFloat = -0.8
        public static let trackingDisplay: CGFloat = -3
        public static let trackingHeading: CGFloat = -0.4
        public static let trackingCompact: CGFloat = -0.7
        public static let trackingMetric: CGFloat = -2
        public static let stickerRotation: CGFloat = 12
        public static let audioInitial: CGFloat = 0.66
        public static let audioStep: CGFloat = 0.1
    }
}

/// Convenience aliases to use Paper Playground scalar tokens directly in SwiftUI layout code.
public extension CGFloat {
    static let xxs = PaperPlaygroundTokens.Space.xxs
    static let xs = PaperPlaygroundTokens.Space.xs
    static let s = PaperPlaygroundTokens.Space.s
    static let m = PaperPlaygroundTokens.Space.m
    static let l = PaperPlaygroundTokens.Space.l
    static let xl = PaperPlaygroundTokens.Space.xl
    static let xxl = PaperPlaygroundTokens.Space.xxl
    static let xxxl = PaperPlaygroundTokens.Space.xxxl
    static let jumbo = PaperPlaygroundTokens.Space.jumbo

    static let grainDot = PaperPlaygroundTokens.Size.grainDot
    static let dot = PaperPlaygroundTokens.Size.dot
    static let spiralGap = PaperPlaygroundTokens.Size.spiralGap
    static let spiralSpineWidth = PaperPlaygroundTokens.Size.spiralSpineWidth
    static let avatar = PaperPlaygroundTokens.Size.avatar
    static let iconButton = PaperPlaygroundTokens.Size.iconButton
    static let badge = PaperPlaygroundTokens.Size.badge
    static let swatchHeight = PaperPlaygroundTokens.Size.swatchHeight
    static let progressRowHeight = PaperPlaygroundTokens.Size.progressRowHeight
    static let sliderTrackHeight = PaperPlaygroundTokens.Size.sliderTrackHeight
    static let displayHero = PaperPlaygroundTokens.Size.displayHero
    static let metricValue = PaperPlaygroundTokens.Size.metricValue
    static let screenBottomInset = PaperPlaygroundTokens.Size.bottomInset

    static let cornerS = PaperPlaygroundTokens.Radius.s
    static let cornerM = PaperPlaygroundTokens.Radius.m
    static let cornerL = PaperPlaygroundTokens.Radius.l
    static let cornerXL = PaperPlaygroundTokens.Radius.xl
    static let cornerXXL = PaperPlaygroundTokens.Radius.xxl
    static let cornerXXXL = PaperPlaygroundTokens.Radius.xxxl
    static let cornerPill = PaperPlaygroundTokens.Radius.pill
    static let cornerDrawer = PaperPlaygroundTokens.Radius.drawer

    static let lineHairline = PaperPlaygroundTokens.Stroke.hairline
    static let lineS = PaperPlaygroundTokens.Stroke.s
    static let lineM = PaperPlaygroundTokens.Stroke.m

    static let trackTight = PaperPlaygroundTokens.Metric.trackingTight
    static let trackDisplay = PaperPlaygroundTokens.Metric.trackingDisplay
    static let trackHeading = PaperPlaygroundTokens.Metric.trackingHeading
    static let trackCompact = PaperPlaygroundTokens.Metric.trackingCompact
    static let trackMetric = PaperPlaygroundTokens.Metric.trackingMetric
    static let appLineSpacing = PaperPlaygroundTokens.Metric.lineSpacing
    static let minimumScale = PaperPlaygroundTokens.Metric.minimumScale
    static let stickerRotation = PaperPlaygroundTokens.Metric.stickerRotation
    static let audioInitial = PaperPlaygroundTokens.Metric.audioInitial
    static let audioStep = PaperPlaygroundTokens.Metric.audioStep
}

/// Convenience aliases for `Double`-based token usage.
public extension Double {
    static let stickerRotation = Double(PaperPlaygroundTokens.Metric.stickerRotation)
    static let audioInitial = Double(PaperPlaygroundTokens.Metric.audioInitial)
    static let audioStep = Double(PaperPlaygroundTokens.Metric.audioStep)
    static let opacitySubtle = PaperPlaygroundTokens.Opacity.subtle
    static let opacityBorder = PaperPlaygroundTokens.Opacity.border
    static let opacitySoft = PaperPlaygroundTokens.Opacity.soft
    static let opacityMedium = PaperPlaygroundTokens.Opacity.medium
    static let opacityWash = PaperPlaygroundTokens.Opacity.wash
    static let opacityAccent = PaperPlaygroundTokens.Opacity.accent
    static let opacityStrong = PaperPlaygroundTokens.Opacity.strong
    static let opacityDisabled = PaperPlaygroundTokens.Opacity.disabled
    static let opacityShadowLight = PaperPlaygroundTokens.Opacity.shadowLight
    static let opacityShadowMedium = PaperPlaygroundTokens.Opacity.shadowMedium
    static let opacityShadowHeavy = PaperPlaygroundTokens.Opacity.shadowHeavy
    static let opacityProgressFilledShadow = PaperPlaygroundTokens.Opacity.progressFilledShadow
    static let opacityProgressCurrentShadow = PaperPlaygroundTokens.Opacity.progressCurrentShadow
    static let opacitySelectedShadow = PaperPlaygroundTokens.Opacity.selectedShadow
    static let opacityIconMuted = PaperPlaygroundTokens.Opacity.iconMuted
}
