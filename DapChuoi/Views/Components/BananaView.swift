//
//  BananaView.swift
//  DapChuoi
//
//  Created by Phạm Anh Khoa on 5/9/25.
//

import Foundation
import SwiftUI

struct BananaView: View {
    // The size of the parent view (screen)
    var parentSize: CGSize
    // Banana image size
    var bananaSize: CGFloat = 120
    // Animation duration
    var duration: Double = 2.0
    // State for position
    @State private var position: CGPoint = .zero
    // State for triggering new random position
    @State private var animate = false

    func randomPosition(in size: CGSize) -> CGPoint {
        let x = CGFloat.random(in: bananaSize...(size.width - bananaSize))
        let y = CGFloat.random(in: bananaSize...(size.height - bananaSize))
        return CGPoint(x: x, y: y)
    }

    var body: some View {
        Image("banana")
            .resizable()
            .scaledToFit()
            .frame(width: bananaSize, height: bananaSize)
            .position(position)
            .onAppear {
                position = randomPosition(in: parentSize)
                withAnimation(Animation.linear(duration: duration).repeatForever(autoreverses: false)) {
                    animate.toggle()
                }
            }
            .onChange(of: animate) { _ in
                // Move to a new random position
                position = randomPosition(in: parentSize)
                // Trigger again
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    animate.toggle()
                }
            }
    }
}

#Preview {
    GeometryReader { geo in
        BananaView(parentSize: geo.size)
    }
}
