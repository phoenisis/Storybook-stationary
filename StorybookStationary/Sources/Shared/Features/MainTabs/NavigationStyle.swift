import SwiftUI

extension View {
    @ViewBuilder
    func paperInlineNavigationBarTitleDisplayMode() -> some View {
        #if os(iOS) || os(tvOS) || os(visionOS)
        self.navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }
}
