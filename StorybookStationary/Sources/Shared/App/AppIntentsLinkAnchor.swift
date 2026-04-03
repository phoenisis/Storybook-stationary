#if canImport(AppIntents)
import AppIntents

/// Ensures `AppIntents.framework` is linked so metadata extraction does not emit tool warnings.
enum AppIntentsLinkAnchor {
    static let appIntentProtocolName = String(describing: AppIntent.self)
}
#endif
