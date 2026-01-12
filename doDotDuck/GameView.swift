//
//  GameView.swift
//  doDotDuck
//
//  Created by cobsccomp24.2p-021 on 2026-01-12.
//

import SwiftUI

struct GameView: View {
    let difficulty: Difficulty
    @StateObject private var vm: GameViewModel
    @Environment(\.dismiss) private var dismiss

    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        _vm = StateObject(wrappedValue: GameViewModel(difficulty: difficulty))
    }

    var body: some View {
        GeometryReader { geo in
            let gridSize = difficulty.gridSize
            let spacing: CGFloat = 8
            let padding: CGFloat = 16

            // Compute tile size based on device width (good for iPhone screens)
            let availableWidth = geo.size.width - (padding * 2) - (spacing * CGFloat(gridSize - 1))
            let tileSize = max(44, floor(availableWidth / CGFloat(gridSize))) // 44 is good tap size

            VStack(spacing: 12) {

                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Moves: \(vm.moves)")
                            .font(.headline)
                        Text("Wrong pick resets (same positions)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding(.horizontal)

                // Message
                if let msg = vm.message {
                    Text(msg)
                        .font(.subheadline)
                        .foregroundStyle(vm.isWin ? .green : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                }

                // Grid
                LazyVGrid(
                    columns: Array(repeating: GridItem(.fixed(tileSize), spacing: spacing), count: gridSize),
                    spacing: spacing
                ) {
                    ForEach(vm.tiles) { tile in
                        TileView(tile: tile)
                            .frame(width: tileSize, height: tileSize)
                            .contentShape(Rectangle()) // ensures tapping works well
                            .onTapGesture {
                                vm.tapTile(tile)
                            }
                            .accessibilityElement()
                            .accessibilityLabel(accessibilityLabel(for: tile))
                            .accessibilityHint("Double tap to flip.")
                    }
                }
                .padding(.horizontal, padding)
                .padding(.top, 6)

                Spacer()

                // Buttons
                HStack(spacing: 12) {
                    Button {
                        vm.newBoard() // reshuffle
                    } label: {
                        Label("New Board", systemImage: "arrow.clockwise")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)

                    Button {
                        vm.resetProgressKeepPositions() // same positions
                    } label: {
                        Label("Reset", systemImage: "gobackward")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
                .padding()
            }
            .padding(.top, 10)
            .navigationTitle("\(difficulty.title) Mode")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Menu") { dismiss() }
                }
            }
            .alert("You Win!", isPresented: $vm.isWin) {
                Button("Play Again") { vm.newBoard() }
                Button("Back to Difficulty", role: .cancel) { dismiss() }
            } message: {
                Text("You matched every pair and found DoDotDuck.")
            }
        }
    }

    private func accessibilityLabel(for tile: Tile) -> String {
        if tile.isMatched { return "Matched tile" }

        if tile.isFaceUp {
            switch tile.content {
            case .duck:
                return "DoDotDuck tile"
            case .colorTile(_, _, let name):
                return "\(name) tile"
            }
        } else {
            return "Hidden tile"
        }
    }
}
