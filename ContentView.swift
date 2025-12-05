import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "swift")
                .font(.system(size: 80))
                .foregroundStyle(.orange)
            
            Text("Welcome to My App")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Your iOS app is ready to build!")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
