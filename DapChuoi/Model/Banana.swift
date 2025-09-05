//
//  Banana.swift
//  DapChuoi
//
//  Created by Phạm Anh Khoa on 5/9/25.
//

import Foundation
import SwiftUI

enum BananaType: String, Codable, CaseIterable {
    case normal
    case bananas
    case ripebanana
    case rottenbanana

    var imageName: String {
        switch self {
        case .normal: return "banana"
        case .bananas: return "bananas"
        case .ripebanana: return "ripebanana"
        case .rottenbanana: return "rottenbanana"
        }
    }

    var baseHealth: Int {
        switch self {
        case .normal: return 10
        case .bananas: return 30
        case .ripebanana: return 3
        case .rottenbanana: return 1
        }
    }

    var stayDuration: Double {
        switch self {
        case .normal: return 10
        case .bananas: return 15
        case .ripebanana: return 7
        case .rottenbanana: return 5
        }
    }
}

struct Banana: Identifiable, Equatable {
    let id: UUID
    var type: BananaType
    var health: Int
    var maxHealth: Int
    var position: CGPoint
    var isAnimating: Bool = false
    var spawnTime: Date
    var stayDuration: Double

    init(type: BananaType, position: CGPoint) {
        self.id = UUID()
        self.type = type
        self.health = type.baseHealth
        self.maxHealth = type.baseHealth
        self.position = position
        self.spawnTime = Date()
        self.stayDuration = type.stayDuration
    }
}
