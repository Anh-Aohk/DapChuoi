//
//  GameViewModel.swift
//  DapChuoi
//
//  Created by Phạm Anh Khoa on 5/9/25.
//

import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    // Player stats
    @Published var bananas: Int = 0
    @Published var multiplier: Int = 1
    @Published var damage: Int = 1
    @Published var critChance: Double = 0.02 // 2% base
    @Published var backgroundColor: Color = .yellow

    // Upgrade costs
    @Published var multiplierCost: Int = 50
    @Published var damageCost: Int = 100
    @Published var critCost: Int = 150

    // Bananas array
    @Published var bananasOnScreen: [Banana] = []
    let maxBananasOnScreen = 5
    let bananaSize: CGFloat = 120

    // Upgrade limits
    let maxDamage = 10
    let maxMultiplier = 10
    let maxCritChance = 0.25 // 25%

    // For random position
    var parentSize: CGSize = .zero

    private var bananaTimer: Timer?
    private var spawnTimer: Timer?
    private var abundanceTimer: Timer?
    // Power-up state
    @Published var isShieldActive: Bool = false
    @Published var shieldTimeRemaining: Int = 0
    let godhammerCost = PowerUpType.godhammer.cost
    let shieldCost = PowerUpType.shield.cost
    private var shieldTimer: Timer?

    // Power-up inventory
    @Published var godhammerCount: Int = 0
    @Published var shieldCount: Int = 0

    init() {
        startBananaTimer()
        startSpawnTimer()
        startAbundanceTimer()
    }

    private func startBananaTimer() {
        bananaTimer?.invalidate()
        bananaTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.removeExpiredBananas()
        }
    }

    private func startSpawnTimer() {
        spawnTimer?.invalidate()
        // Increased interval for less frequent spawns
        spawnTimer = Timer.scheduledTimer(withTimeInterval: Double.random(in: 1.5...3.0), repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.bananasOnScreen.count < self.maxBananasOnScreen {
                self.spawnBanana(in: self.parentSize)
            }
            // Restart timer with new random interval
            self.startSpawnTimer()
        }
    }

    private func startAbundanceTimer() {
        abundanceTimer?.invalidate()
        abundanceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tryAbundanceEvent()
        }
    }

    private func tryAbundanceEvent() {
        // 1% chance
        if Double.random(in: 0...1) < 0.01 {
            self.spawnAbundanceBananas()
        }
    }

    // Weighted random banana type selection
    private func weightedRandomBananaType() -> BananaType {
        let weightedTypes: [(BananaType, Int)] = [
            (.normal, 50),
            (.ripebanana, 30),
            (.bananas, 15),
            (.rottenbanana, 5)
        ]
        let total = weightedTypes.reduce(0) { $0 + $1.1 }
        let rand = Int.random(in: 0..<total)
        var sum = 0
        for (type, weight) in weightedTypes {
            sum += weight
            if rand < sum { return type }
        }
        return .normal // fallback
    }

    private func spawnAbundanceBananas() {
        guard parentSize.width > 0, parentSize.height > 0 else { return }
        let topInset: CGFloat = 120
        let abundanceBottom: CGFloat = parentSize.height / 2.2 // upper part of the screen
        let spacing: CGFloat = bananaSize * 1.1
        let minX = bananaSize
        let maxX = parentSize.width - bananaSize
        let minY = topInset + bananaSize
        let maxY = abundanceBottom - bananaSize
        var positions: [CGPoint] = []
        var y = minY
        while y <= maxY {
            var x = minX
            while x <= maxX {
                let point = CGPoint(x: x, y: y)
                if !bananasOnScreen.contains(where: { $0.position.distance(to: point) < bananaSize }) {
                    positions.append(point)
                }
                x += spacing
            }
            y += spacing
        }
        // Shuffle positions for randomness
        positions.shuffle()
        var bananasAdded = 0
        for pos in positions {
            if bananasOnScreen.count >= 100 { break }
            if bananasAdded >= 20 { break }
            let type: BananaType = weightedRandomBananaType()
            let banana = Banana(type: type, position: pos)
            bananasOnScreen.append(banana)
            bananasAdded += 1
        }
        // If less than 20 placed, try random positions in the upper area
        let maxAttempts = 100
        var attempts = 0
        while bananasAdded < 20 && attempts < maxAttempts {
            let x = CGFloat.random(in: minX...maxX)
            let y = CGFloat.random(in: minY...maxY)
            let pos = CGPoint(x: x, y: y)
            if !bananasOnScreen.contains(where: { $0.position.distance(to: pos) < bananaSize }) {
                let type: BananaType = weightedRandomBananaType()
                let banana = Banana(type: type, position: pos)
                bananasOnScreen.append(banana)
                bananasAdded += 1
            }
            attempts += 1
        }
    }

    private func removeExpiredBananas() {
        let now = Date()
        bananasOnScreen.removeAll { now.timeIntervalSince($0.spawnTime) > $0.stayDuration }
    }

    // MARK: - Banana Spawning
    func spawnBanana(in size: CGSize, topInset: CGFloat = 120, bottomInset: CGFloat = 180) {
        guard bananasOnScreen.count < maxBananasOnScreen else { return }
        let type: BananaType = weightedRandomBananaType()
        var position: CGPoint
        var attempts = 0
        let maxAttempts = 10
        repeat {
            position = randomSafePosition(in: size, topInset: topInset, bottomInset: bottomInset)
            attempts += 1
        } while bananasOnScreen.contains(where: { $0.position.distance(to: position) < bananaSize * 0.9 }) && attempts < maxAttempts
        // Only add if not overlapping
        if !bananasOnScreen.contains(where: { $0.position.distance(to: position) < bananaSize * 0.9 }) {
            let banana = Banana(type: type, position: position)
            bananasOnScreen.append(banana)
        }
    }

    func randomPosition(in size: CGSize) -> CGPoint {
        guard size.width > bananaSize * 2, size.height > bananaSize * 2 else {
            return CGPoint(x: size.width / 2, y: size.height / 2)
        }
        let x = CGFloat.random(in: bananaSize...(size.width - bananaSize))
        let y = CGFloat.random(in: bananaSize...(size.height - bananaSize))
        return CGPoint(x: x, y: y)
    }

    func randomSafePosition(in size: CGSize, topInset: CGFloat, bottomInset: CGFloat) -> CGPoint {
        let margin = bananaSize / 2
        let minX = margin
        let maxX = size.width - margin
        let minY = topInset + margin
        let maxY = size.height - bottomInset - margin
        guard maxX > minX, maxY > minY else {
            return CGPoint(x: size.width / 2, y: size.height / 2)
        }
        let x = CGFloat.random(in: minX...maxX)
        let y = CGFloat.random(in: minY...maxY)
        return CGPoint(x: x, y: y)
    }

    // MARK: - Banana Hit Logic
    func hitBanana(id: UUID) -> (isCrit: Bool, isDead: Bool) {
        guard let idx = bananasOnScreen.firstIndex(where: { $0.id == id }) else { return (false, false) }
        let isCrit = Double.random(in: 0...1) < critChance
        let actualDamage = isCrit ? Int(Double(damage) * 1.5) : damage
        bananasOnScreen[idx].health -= actualDamage
        let isDead = bananasOnScreen[idx].health <= 0
        if isDead {
            let bananaType = bananasOnScreen[idx].type
            switch bananaType {
            case .normal:
                bananas += 2
            case .ripebanana:
                bananas += 1
            case .bananas:
                bananas += 5 * multiplier
            case .rottenbanana:
                if !isShieldActive {
                    bananas -= 10 * multiplier
                    if bananas < 0 { bananas = 0 }
                }
            default:
                bananas += multiplier
            }
            bananasOnScreen.remove(at: idx)
        }
        return (isCrit, isDead)
    }

    // MARK: - Banana Animation
    func moveBanana(id: UUID, in size: CGSize) {
        guard let idx = bananasOnScreen.firstIndex(where: { $0.id == id }) else { return }
        bananasOnScreen[idx].position = randomPosition(in: size)
    }

    // MARK: - Upgrades
    func upgradeMultiplier() {
        guard bananas >= multiplierCost, multiplier < maxMultiplier else { return }
        bananas -= multiplierCost
        multiplier += 1
        multiplierCost = Int(Double(multiplierCost) * 1.5)
    }

    func upgradeDamage() {
        guard bananas >= damageCost, damage < maxDamage else { return }
        bananas -= damageCost
        damage += 1
        damageCost = Int(Double(damageCost) * 1.7)
    }

    func upgradeCrit() {
        guard bananas >= critCost, critChance < maxCritChance else { return }
        bananas -= critCost
        critChance += 0.05
        critCost = Int(Double(critCost) * 2)
    }

    func setBackgroundColor(_ color: Color) {
        backgroundColor = color
    }

    // MARK: - Power-Ups
    func activateGodHammer() {
        guard canUseGodHammer else { return }
        godhammerCount -= 1
        bananasOnScreen.removeAll()
    }

    func activateShield() {
        guard canUseShield else { return }
        shieldCount -= 1
        isShieldActive = true
        shieldTimeRemaining = 30
        shieldTimer?.invalidate()
        shieldTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.shieldTimeRemaining -= 1
            if self.shieldTimeRemaining <= 0 {
                self.isShieldActive = false
                timer.invalidate()
            }
        }
    }

    // Power-up shop purchase
    func buyPowerUp(_ type: PowerUpType) {
        switch type {
        case .godhammer:
            guard bananas >= godhammerCost else { return }
            bananas -= godhammerCost
            godhammerCount += 1
        case .shield:
            guard bananas >= shieldCost else { return }
            bananas -= shieldCost
            shieldCount += 1
        }
    }

    // MARK: - Game Loop Helpers
    func ensureBananas(in size: CGSize) {
        while bananasOnScreen.count < maxBananasOnScreen {
            spawnBanana(in: size)
        }
    }

    func resetGame(in size: CGSize) {
        bananasOnScreen.removeAll()
        ensureBananas(in: size)
    }

    deinit {
        bananaTimer?.invalidate()
        spawnTimer?.invalidate()
        abundanceTimer?.invalidate()
        shieldTimer?.invalidate()
    }
}

// MARK: - CGPoint Distance Extension
extension CGPoint {
    func distance(to other: CGPoint) -> CGFloat {
        let dx = x - other.x
        let dy = y - other.y
        return sqrt(dx * dx + dy * dy)
    }
}

// MARK: - Power-Up Usage Conditions
extension GameViewModel {
    var canUseGodHammer: Bool {
        godhammerCount > 0
    }
    var canUseShield: Bool {
        shieldCount > 0 && !isShieldActive
    }
}
