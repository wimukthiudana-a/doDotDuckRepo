//
//  models.swift
//  doDotDuck
//
//  Created by cobsccomp24.2p-021 on 2026-01-12.
//

import SwiftUI

// What is inside a tile
enum TileContent: Equatable {
    case colorTile(color: Color, symbol: String, name: String)
    case duck
}

// One tile on the board
struct Tile: Identifiable, Equatable {
    let id = UUID()
    let content: TileContent
    var isFaceUp: Bool = false
    var isMatched: Bool = false
}
