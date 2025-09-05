//
//  ShopView.swift
//  DapChuoi
//
//  Created by Phạm Anh Khoa on 5/9/25.
//

import Foundation
import SwiftUI

struct ShopView: View {
    @EnvironmentObject var viewModel: GameViewModel
    var body: some View {
        VStack(spacing: 24) {
            Text("Shop")
                .font(.largeTitle)
                .bold()
            Text("Bananas: \(viewModel.bananas)")
                .font(.title2)
                .foregroundColor(.yellow)
            VStack(spacing: 16) {
                // Multiplier Upgrade
                HStack {
                    Text("Multiplier: x\(viewModel.multiplier)")
                    Spacer()
                    Button(action: { viewModel.upgradeMultiplier() }) {
                        Text("Upgrade (\(viewModel.multiplierCost))")
                            .padding(8)
                            .background(viewModel.bananas >= viewModel.multiplierCost && viewModel.multiplier < viewModel.maxMultiplier ? Color.green : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                // Damage Upgrade
                HStack {
                    Text("Damage: \(viewModel.damage)")
                    Spacer()
                    Button(action: { viewModel.upgradeDamage() }) {
                        Text("Upgrade (\(viewModel.damageCost))")
                            .padding(8)
                            .background(viewModel.bananas >= viewModel.damageCost && viewModel.damage < viewModel.maxDamage ? Color.red : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                // Crit Chance Upgrade
                HStack {
                    Text("Crit: \(Int(viewModel.critChance * 100))%")
                    Spacer()
                    Button(action: { viewModel.upgradeCrit() }) {
                        Text("Upgrade (\(viewModel.critCost))")
                            .padding(8)
                            .background(viewModel.bananas >= viewModel.critCost && viewModel.critChance < viewModel.maxCritChance ? Color.purple : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                // Power-ups
                HStack(spacing: 32) {
                    VStack {
                        Button(action: { viewModel.buyPowerUp(.godhammer) }) {
                            Image("godhammer")
                                .resizable()
                                .frame(width: 48, height: 48)
                                .opacity(viewModel.bananas >= viewModel.godhammerCost ? 1.0 : 0.5)
                        }
                        Text("Godhammer")
                            .font(.caption)
                        Text("\(viewModel.godhammerCost)")
                            .font(.caption2)
                            .foregroundColor(.yellow)
                    }
                    VStack {
                        Button(action: { viewModel.buyPowerUp(.shield) }) {
                            Image("shield")
                                .resizable()
                                .frame(width: 48, height: 48)
                                .opacity(viewModel.bananas >= viewModel.shieldCost ? 1.0 : 0.5)
                        }
                        Text("Shield")
                            .font(.caption)
                        Text("\(viewModel.shieldCost)")
                            .font(.caption2)
                            .foregroundColor(.yellow)
                    }
                }
            }
            .padding(.horizontal)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ShopView().environmentObject(GameViewModel())
}
