# PaperPlaygroundDesignSystem

A SwiftUI-first design system package for the **Paper Playground** visual language.

`PaperPlaygroundDesignSystem` centralizes:
- semantic colors and gradients
- typography and scalar tokens
- reusable UI components
- reusable style modifiers
- shared motion presets
- UIKit/SwiftUI appearance integration helpers

Platforms:
- iOS 26+
- macOS 26+

## Installation

### Swift Package (local package)

```swift
.package(path: "Packages/PaperPlaygroundDesignSystem")
```

Then add product dependency:

```swift
.package(product: "PaperPlaygroundDesignSystem")
```

### Optional app-level re-export

If you want feature files to use the design system without importing it explicitly:

```swift
@_exported import PaperPlaygroundDesignSystem
```

## Quick Start

### 1) Install global UIKit appearance once (iOS)

```swift
PaperPlaygroundThemeInstaller.installUIKitAppearance()
```

This configures navigation bars, tab bars, segmented controls, switches, and page controls.

### 2) Use SwiftUI style helpers where needed

```swift
TabView {
  // tabs
}
.paperPlaygroundTabBarStyle()
```

```swift
NavigationStack {
  // content
}
.paperPlaygroundNavigationLargeTitleStyle(.appPrimary)
```

Note: `paperPlaygroundNavigationLargeTitleStyle` is **opt-in** and not applied globally.

## Tokens

## Scalar Tokens

Primary token namespace:
- `PaperPlaygroundTokens.Space`
- `PaperPlaygroundTokens.Size`
- `PaperPlaygroundTokens.Radius`
- `PaperPlaygroundTokens.Stroke`
- `PaperPlaygroundTokens.Opacity`
- `PaperPlaygroundTokens.Metric`
- `PaperPlaygroundTokens.Effect`

Convenience aliases are available directly on `CGFloat` and `Double`.

Examples:

```swift
.padding(.vertical, .l)
.padding(.horizontal, .xxl)
.frame(width: .iconButton, height: .iconButton)
.clipShape(RoundedRectangle(tokenRadius: .cornerXXL))
.shadow(color: .black.opacity(.opacityShadowMedium), radius: .xl, x: 0, y: .m)
```

### Typography Tokens

```swift
.font(.appTitle)
.font(.sectionTitle)
.font(.displayHero)
.font(.headingL)
.font(.metricValue)
.font(.bodyM)
.font(.bodyS)
.font(.labelM)
.font(.labelS)
```

## Color System

### Raw Palette Namespace

```swift
Color.PaperPlayground.primary
Color.PaperPlayground.secondary
Color.PaperPlayground.tertiary
```

### Semantic Helpers (preferred)

```swift
Color.appPrimary
Color.appSecondary
Color.tertiary
Color.background
Color.surface
Color.onSurface
Color.outline
```

## Gradient System

```swift
LinearGradient.paperSurfaceFade
LinearGradient.primarySticker
LinearGradient.tertiarySticker
```

`ShapeStyle` shortcuts are also available:

```swift
.fill(.paperSurfaceFade)
.fill(.primarySticker)
.fill(.tertiarySticker)
```

## Motion

Use standardized motion presets:

```swift
withAnimation(.appNavigation) {
  // tab/navigation-like movement
}

withAnimation(.appButtonPress) {
  // pressed/released interactions
}
```

## Components

- `SectionHeader(icon:title:color:)`
- `PaletteSwatch(name:color:textColor:)`
- `StickerStatePill(name:fill:text:)`
- `ProgressDot(state:)`
- `SpiralNotebookCard(title:description:)`
- `PaperGrainOverlay()`

## Style Modifiers

- `StickerDepthButtonStyle(color:cornerRadius:)`
- `.paperCard()`
- `.notebookShadow()`
- `.paperPlaygroundTabBarStyle()`
- `.paperPlaygroundNavigationLargeTitleStyle(_:)`

## Token Convenience Initializers

- `EdgeInsets(horizontal:vertical:)`
- `RoundedRectangle(tokenRadius:style:)`
- `StrokeStyle(tokenLineWidth:dash:)`

## Usage Example

```swift
import SwiftUI
import PaperPlaygroundDesignSystem

struct ExampleCard: View {
  var body: some View {
    VStack(alignment: .leading, spacing: .l) {
      SectionHeader(icon: "paintpalette.fill", title: "Theme", color: .tertiary)

      PaletteSwatch(name: "Primary", color: .appPrimary, textColor: .white)

      Button("Primary") {}
        .font(.labelM.weight(.black))
        .buttonStyle(StickerDepthButtonStyle(color: .appPrimary))
    }
    .padding(.xxl)
    .paperCard()
    .background(Color.background)
  }
}
```

## Architecture Notes

- Keep product/UI logic in app features (for example TCA reducers).
- Keep visual language and constants in this package.
- Prefer semantic APIs (`Color.appPrimary`, `.paperCard()`, `.appButtonPress`) over hard-coded values.
- Use opt-in appearance helpers for context-specific behavior.

