import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// Opt-in navigation title styling helpers for Paper Playground screens.
public extension View {
    /// Applies Paper Playground large-title styling to a navigation surface.
    ///
    /// This modifier customizes the large title color while preserving the default inline title
    /// rendering so collapsed navigation bars keep system behavior.
    ///
    /// - Parameter color: Large title foreground color. Defaults to ``Color/appPrimary``.
    /// - Returns: A view that reapplies large title styling during navigation lifecycle events.
    func paperPlaygroundNavigationLargeTitleStyle(_ color: Color = .appPrimary) -> some View {
        modifier(PaperPlaygroundLargeTitleColorModifier(color: color))
    }
}

private struct PaperPlaygroundLargeTitleColorModifier: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
#if canImport(UIKit)
        content.background(
            PaperPlaygroundLargeTitleConfigurator(color: UIColor(color))
        )
#else
        content
#endif
    }
}

#if canImport(UIKit)
private struct PaperPlaygroundLargeTitleConfigurator: UIViewControllerRepresentable {
    let color: UIColor

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = HostingController()
        controller.applyAppearance = applyAppearance(from:)
        return controller
    }

    func updateUIViewController(_ viewController: UIViewController, context: Context) {
        (viewController as? HostingController)?.applyAppearance = applyAppearance(from:)
        // Defer one run loop so the representable is attached to the final navigation hierarchy.
        DispatchQueue.main.async {
            applyAppearance(from: viewController)
        }
    }

    private func applyAppearance(from viewController: UIViewController) {
        guard let navigationController = findNavigationController(from: viewController) else { return }

        let navigationBar = navigationController.navigationBar

        let standardAppearance = navigationBar.standardAppearance.copy()
        standardAppearance.configureWithTransparentBackground()

        let scrollEdgeAppearance = navigationBar.scrollEdgeAppearance?.copy() as? UINavigationBarAppearance ?? UINavigationBarAppearance()
        scrollEdgeAppearance.configureWithTransparentBackground()

        var largeAttributes = scrollEdgeAppearance.largeTitleTextAttributes
        largeAttributes[.foregroundColor] = color
        scrollEdgeAppearance.largeTitleTextAttributes = largeAttributes

        navigationBar.standardAppearance = standardAppearance
        navigationBar.compactAppearance = standardAppearance
        navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
        
    }

    private func findNavigationController(from viewController: UIViewController?) -> UINavigationController? {
        var current = viewController
        while let candidate = current {
            if let navigationController = candidate.navigationController {
                return navigationController
            }
            current = candidate.parent
        }
        return nil
    }

    private final class HostingController: UIViewController {
        var applyAppearance: ((UIViewController) -> Void)?

        override func didMove(toParent parent: UIViewController?) {
            super.didMove(toParent: parent)
            applyAppearance?(self)
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            applyAppearance?(self)
        }
    }
}
#endif
