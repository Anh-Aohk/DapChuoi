//
//  PowerUp.swift
//  DapChuoi
//
//  Created by Phạm Anh Khoa on 5/9/25.
//

import Foundation

enum PowerUpType: String, Codable, CaseIterable {
    case godhammer
    case shield

    var displayName: String {
        switch self {
        case .godhammer: return "God Hammer"
        case .shield: return "Shield"
        }
    }

    var cost: Int {
        switch self {
        case .godhammer: return 100
        case .shield: return 80
        }
    }
}
