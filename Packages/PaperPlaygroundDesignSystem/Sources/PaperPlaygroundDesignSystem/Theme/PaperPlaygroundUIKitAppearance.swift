#if canImport(UIKit)
import SwiftUI
import UIKit

/// Installer for Paper Playground UIKit appearance defaults.
public enum PaperPlaygroundThemeInstaller {
    /// Applies Paper Playground `UIAppearance` values globally for UIKit-backed controls.
    ///
    /// Call once during app startup on iOS.
    public static func installUIKitAppearance() {
        let palette = Palette()
        let typography = Typography()

        UIView.appearance().tintColor = palette.primary
        UIBarButtonItem.appearance().tintColor = palette.primary

        configureNavigationBar(palette: palette, typography: typography)
        configureTabBar(palette: palette)
        configureControls(palette: palette, typography: typography)
    }
}

private extension PaperPlaygroundThemeInstaller {
    static func configureNavigationBar(palette: Palette, typography: Typography) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: palette.onSurface,
            .font: typography.navigationTitle
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: palette.onSurface,
            .font: typography.navigationLargeTitle
        ]

        let backImage = UIImage(
            systemName: "chevron.backward",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold)
        )
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = palette.primary
    }

    static func configureTabBar(palette: Palette) {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundColor = palette.surface.withAlphaComponent(0.86)
        appearance.shadowColor = .clear

        let normal: [NSAttributedString.Key: Any] = [.foregroundColor: palette.outline]
        let selected: [NSAttributedString.Key: Any] = [.foregroundColor: palette.primary]

        appearance.stackedLayoutAppearance.normal.iconColor = palette.outline
        appearance.stackedLayoutAppearance.selected.iconColor = palette.primary
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normal
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selected

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().tintColor = palette.primary
        UITabBar.appearance().unselectedItemTintColor = palette.outline
        UITabBar.appearance().itemPositioning = .fill
        UITabBar.appearance().itemWidth = 0
        UITabBar.appearance().itemSpacing = 0
        UITabBar.appearance().layer.cornerCurve = .continuous
        UITabBar.appearance().layer.cornerRadius = 28
        UITabBar.appearance().layer.masksToBounds = true
    }

    static func configureControls(palette: Palette, typography: Typography) {
        UISegmentedControl.appearance().selectedSegmentTintColor = palette.primaryContainer
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: palette.onSurface, .font: typography.body],
            for: .normal
        )
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: palette.onPrimaryContainer, .font: typography.body],
            for: .selected
        )

        UISwitch.appearance().onTintColor = palette.tertiary
        UIPageControl.appearance().currentPageIndicatorTintColor = palette.tertiary
        UIPageControl.appearance().pageIndicatorTintColor = palette.outlineVariant.withAlphaComponent(0.5)
    }
}

private struct Palette {
    let primary = UIColor(Color.appPrimary)
    let primaryContainer = UIColor(Color.appPrimaryContainer)
    let onPrimaryContainer = UIColor(Color.appOnPrimaryContainer)

    let tertiary = UIColor(Color.tertiary)

    let background = UIColor(Color.background)
    let surface = UIColor(Color.surface)
    let onSurface = UIColor(Color.onSurface)
    let outline = UIColor(Color.outline)
    let outlineVariant = UIColor(Color.outlineVariant)
}

private struct Typography {
    let navigationTitle = UIFont.systemFont(ofSize: 17, weight: .black)
    let navigationLargeTitle = UIFont.systemFont(ofSize: 34, weight: .heavy)
    let body = UIFont.systemFont(ofSize: 15, weight: .semibold)
}
#endif
