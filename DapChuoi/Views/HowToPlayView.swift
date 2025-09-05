import SwiftUI

struct HowToPlayView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("How to Play").font(.title2).bold()) {
                    Text("1. Tap on bananas to earn points.")
                    Text("2. Bananas appear randomly and disappear after a short time.")
                    Text("3. Upgrade your damage, multiplier, and crit chance in the shop.")
                }
            }
            .navigationTitle("How to Play")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    HowToPlayView()
}
