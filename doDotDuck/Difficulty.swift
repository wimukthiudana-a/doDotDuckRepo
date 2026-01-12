//
//  Difficulty.swift
//  doDotDuck
//
//  Created by cobsccomp24.2p-021 on 2026-01-12.
//

import Foundation

enum Difficulty: String, CaseIterable, Identifiable {
    case easy, medium, hard
    var id: String { rawValue }

    var gridSize: Int {
        switch self {
        case .easy: return 3
        case .medium: return 5
        case .hard: return 7
        }
    }

    var title: String { rawValue.capitalized }

    var subtitle: String {
        "\(gridSize) × \(gridSize) tiles"
    }
}
