import SwiftUI

struct StorybookPlaceholderTabView: View {
    let title: String
    let icon: String

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()

            VStack(spacing: .xxl) {
                Image(systemName: icon)
                    .font(.system(size: 56, weight: .black))
                    .foregroundStyle(Color.appPrimary)

                Text(title)
                    .font(.displayHero.weight(.black))
                    .tracking(.trackHeading)
                    .foregroundStyle(Color.appPrimary)
                    .multilineTextAlignment(.center)

                Text("Cette section arrive bientot.")
                    .font(.bodyM)
                    .foregroundStyle(Color.onSurfaceVariant)
            }
            .padding(.xxxl)
            .paperCard()
            .padding(.xxxl)

            PaperGrainOverlay()
        }
    }
}
