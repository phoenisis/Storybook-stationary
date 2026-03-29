import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "book.closed")
                .font(.system(size: 42))
            Text("Storybook stationary")
                .font(.title)
                .fontWeight(.semibold)
            Text("iOS, iPadOS, and macOS ready")
                .foregroundStyle(.secondary)
        }
        .padding(24)
    }
}

#Preview {
    ContentView()
}
