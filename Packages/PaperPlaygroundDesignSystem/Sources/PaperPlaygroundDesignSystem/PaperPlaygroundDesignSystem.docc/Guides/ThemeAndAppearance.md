# Theme And Appearance

Configure the design system once at app launch, then use opt-in SwiftUI helpers where needed.

## Install Global UIKit Appearance (iOS)

Call this in your app initializer:

```swift
PaperPlaygroundThemeInstaller.installUIKitAppearance()
```

This configures:

- navigation bar appearance
- tab bar appearance
- segmented control typography/colors
- switch and page control tinting

## Apply SwiftUI Styling Helpers

Use tab and large-title helpers in SwiftUI surfaces:

```swift
TabView {
  // tabs
}
.paperPlaygroundTabBarStyle()
```

```swift
NavigationStack {
  // screen content
}
.paperPlaygroundNavigationLargeTitleStyle(.appPrimary)
```

`paperPlaygroundNavigationLargeTitleStyle` is intentionally opt-in so each screen can decide if large-title color should be customized.

## Re-exporting In Apps

For ergonomic imports across feature files, create an app-level bridge:

```swift
@_exported import PaperPlaygroundDesignSystem
```
