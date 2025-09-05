//
//  SettingsView.swift
//  DapChuoi
//
//  Created by Phạm Anh Khoa on 5/9/25.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: GameViewModel
    let colors: [Color] = [.yellow, .blue, .green, .orange, .pink, .purple, .white]
    var body: some View {
        VStack(spacing: 24) {
            Text("Settings")
                .font(.largeTitle)
                .bold()
            Text("Background Color")
                .font(.title2)
            HStack(spacing: 16) {
                ForEach(colors, id: \.self) { color in
                    Button(action: {
                        viewModel.setBackgroundColor(color)
                    }) {
                        Circle()
                            .fill(color)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .stroke(viewModel.backgroundColor == color ? Color.black : Color.clear, lineWidth: 3)
                            )
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    SettingsView().environmentObject(GameViewModel())
}
