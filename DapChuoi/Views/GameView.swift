import SwiftUI

struct GameView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @State private var showCrit = false
    @State private var bananaPosition: CGPoint = .zero
    @State private var parentSize: CGSize = .zero
    @State private var animate = false
    @State private var isActive = true // Track if view is active
    let animationDuration: Double = 2.0
    let topInset: CGFloat = 120 // Space for score and top UI
    let bottomInset: CGFloat = 180 // Space for buttons and bottom UI

    var body: some View {
        ZStack {
            viewModel.backgroundColor.ignoresSafeArea()
            GeometryReader { geo in
                let safeArea = geo.size
                VStack(spacing: 32) {
                    Text("Bananas: \(viewModel.bananas)")
                        .font(.title2)
                        .foregroundColor(.yellow)
                    Spacer()
                    ZStack {
                        ForEach(viewModel.bananasOnScreen) { banana in
                            Image(banana.type.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: viewModel.bananaSize, height: viewModel.bananaSize)
                                .position(banana.position)
                                .shadow(radius: 8)
                                .onTapGesture {
                                    let result = viewModel.hitBanana(id: banana.id)
                                    if result.isCrit {
                                        showCrit = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            showCrit = false
                                        }
                                    }
                                }
                        }
                        if showCrit {
                            Text("CRIT!")
                                .font(.system(size: 40, weight: .black, design: .rounded))
                                .foregroundColor(.red)
                                .shadow(radius: 4)
                                .transition(.scale)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    Spacer()
                    Button(action: {
                        viewModel.backgroundColor = Color(
                            red: .random(in: 0...1),
                            green: .random(in: 0...1),
                            blue: .random(in: 0...1)
                        )
                    }) {
                        Text("Change Background Color")
                            .font(.headline)
                            .padding()
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(12)
                            .shadow(radius: 2)
                    }
                    HStack(spacing: 24) {
                        Text("DMG: \(viewModel.damage)")
                            .font(.subheadline)
                            .foregroundColor(.red)
                        Text("x\(viewModel.multiplier)")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                        Text("Crit: \(Int(viewModel.critChance * 100))%")
                            .font(.subheadline)
                            .foregroundColor(.purple)
                    }
                }
                .padding()
                .onAppear {
                    isActive = true
                    parentSize = safeArea
                    viewModel.parentSize = safeArea
                    // Fill up bananas to max on appear
                    while viewModel.bananasOnScreen.count < viewModel.maxBananasOnScreen {
                        viewModel.spawnBanana(in: safeArea, topInset: topInset, bottomInset: bottomInset)
                    }
                }
                .onChange(of: geo.size) { newSize in
                    parentSize = newSize
                    viewModel.parentSize = newSize
                }
            }
        }
        .onDisappear { isActive = false }
    }
}

#Preview {
    GameView().environmentObject(GameViewModel())
}
