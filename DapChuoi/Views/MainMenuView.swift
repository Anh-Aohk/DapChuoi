//
//  MainMenuView.swift
//  DapChuoi
//
//  Created by Phạm Anh Khoa on 5/9/25.
//

import Foundation
import SwiftUI

struct MainMenuView: View {
    @State private var showSettings = false
    @State private var showHowToPlay = false
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Color(.systemYellow).opacity(0.1).ignoresSafeArea()
                VStack(spacing: 32) {
                    Spacer()
                    // Monkey character image
                    Image("monkey")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                        .shadow(radius: 8)
                    Text("Đập chuối")
                        .font(.system(size: 40, weight: .heavy, design: .rounded))
                        .foregroundColor(.orange)
                        .shadow(radius: 2)
                    // Start Game Button
                    NavigationLink(destination: GameView()) {
                        Text("START")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.red)
                            .cornerRadius(16)
                            .shadow(radius: 4)
                    }
                    .padding(.horizontal, 32)
                    // Shop Button
                    NavigationLink(destination: ShopView()) {
                        HStack(spacing: 12) {
                            Image("shop")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                            Text("Shop")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.brown)
                        }
                        .padding(.horizontal, 32)
                        .padding(.vertical, 10)
                        .background(Color.yellow.opacity(0.7))
                        .cornerRadius(12)
                        .shadow(radius: 2)
                    }
                    // How to Play Button
                    Button(action: { showHowToPlay = true }) {
                        HStack(spacing: 12) {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.blue)
                            Text("How to Play")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal, 32)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                        .shadow(radius: 2)
                    }
                    .sheet(isPresented: $showHowToPlay) {
                        HowToPlayView()
                    }
                    Spacer()
                }
                // Settings Button (top left)
                Button(action: { showSettings = true }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.gray)
                        .padding(16)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .padding(.top, 16)
                .padding(.leading, 16)
                .sheet(isPresented: $showSettings) {
                    SettingsView()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    MainMenuView()
}
