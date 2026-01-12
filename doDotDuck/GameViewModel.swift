//
//  GameViewModel.swift
//  doDotDuck
//
//  Created by cobsccomp24.2p-021 on 2026-01-12.
//

import SwiftUI
import Combine

@MainActor
final class GameViewModel: ObservableObject {

    // Published so UI updates automatically
    @Published private(set) var tiles: [Tile] = []
    @Published private(set) var moves: Int = 0
    @Published var message: String? = nil
    @Published var isWin: Bool = false

    private var firstPickIndex: Int? = nil
    private var isBusy: Bool = false

    let difficulty: Difficulty

    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        newBoard() // make a shuffled board once at start
    }

    // MARK: - Public actions

    /// New Board = NEW shuffle (positions change)
    func newBoard() {
        moves = 0
        message = nil
        isWin = false
        firstPickIndex = nil
        isBusy = false

        tiles = makeBoard(gridSize: difficulty.gridSize)
    }

    /// Reset Progress = positions DO NOT change (your rule)
    func resetProgressKeepPositions(showMessage: Bool = true) {
        firstPickIndex = nil
        isBusy = false
        moves = 0
        isWin = false

        if showMessage {
            message = "Reset (same positions)."
        }

        for i in tiles.indices {
            tiles[i].isFaceUp = false
            tiles[i].isMatched = false
        }
    }

    func tapTile(_ tile: Tile) {
        // find the tile index
        guard let index = tiles.firstIndex(where: { $0.id == tile.id }) else { return }

        // block taps while we are waiting to reset
        guard !isBusy else { return }

        // ignore if already matched or already face up
        guard !tiles[index].isMatched else { return }
        guard !tiles[index].isFaceUp else { return }

        // flip the tile up
        tiles[index].isFaceUp = true

        // If it is the duck tile, it becomes matched immediately
        if case .duck = tiles[index].content {
            tiles[index].isMatched = true
            message = "You found DoDotDuck 🦆"
            checkWin()
            return
        }

        // First pick
        if firstPickIndex == nil {
            firstPickIndex = index
            message = "Pick one more tile."
            return
        }

        // Second pick
        let firstIndex = firstPickIndex!
        firstPickIndex = nil
        moves += 1

        let a = tiles[firstIndex].content
        let b = tiles[index].content

        // Match check
        if a == b {
            tiles[firstIndex].isMatched = true
            tiles[index].isMatched = true
            message = "Matched ✅"
            checkWin()
        } else {
            // Wrong → show for a short time → reset progress (no reshuffle)
            isBusy = true
            message = "Wrong ❌ Resetting (same positions)…"

            Task {
                try? await Task.sleep(nanoseconds: 700_000_000)
                resetProgressKeepPositions(showMessage: true)
            }
        }
    }

    // MARK: - Win check

    private func checkWin() {
        if tiles.allSatisfy({ $0.isMatched }) {
            isWin = true
            message = "You win! 🏆🦆"
        }
    }

    // MARK: - Board generation

    private func makeBoard(gridSize: Int) -> [Tile] {
        let total = gridSize * gridSize

        // 1 duck tile so the rest is even for pairs
        let pairTilesCount = total - 1
        let pairCount = pairTilesCount / 2

        // Colors + symbols (symbols help even if user cannot see colors well)
        let palette: [(Color, String, String)] = [
            (.red, "R", "Red"),
            (.green, "G", "Green"),
            (.yellow, "Y", "Yellow"),
            (.blue, "B", "Blue"),
            (.purple, "P", "Purple"),
            (.orange, "O", "Orange"),
            (.pink, "Pi", "Pink"),
            (.mint, "M", "Mint"),
            (.teal, "T", "Teal"),
            (.indigo, "I", "Indigo"),
            (.brown, "Br", "Brown"),
            (.cyan, "C", "Cyan")
        ]

        var contents: [TileContent] = []
        contents.reserveCapacity(total)

        // Add pairs
        for i in 0..<pairCount {
            let item = palette[i % palette.count]
            let c = TileContent.colorTile(color: item.0, symbol: item.1, name: item.2)
            contents.append(c)
            contents.append(c)
        }

        // Add 1 duck
        contents.append(.duck)

        // Shuffle ONCE (this sets the fixed positions for the round)
        contents.shuffle()

        // Create tiles
        return contents.map { Tile(content: $0) }
    }
}
