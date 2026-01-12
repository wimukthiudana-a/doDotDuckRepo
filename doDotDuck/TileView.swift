//
//  TileView.swift
//  doDotDuck
//
//  Created by cobsccomp24.2p-021 on 2026-01-12.
//

import SwiftUI

struct TileView: View {
    let tile: Tile

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(backgroundFill)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(.gray.opacity(0.25), lineWidth: 1)
                )
                .shadow(radius: 2, y: 1)

            tileContentView
        }
        .animation(.easeInOut(duration: 0.18), value: tile.isFaceUp)
        .animation(.easeInOut(duration: 0.18), value: tile.isMatched)
    }

    private var backgroundFill: Color {
        if tile.isMatched {
            return Color.green.opacity(0.18)
        }

        if tile.isFaceUp {
            switch tile.content {
            case .duck:
                return Color.orange.opacity(0.25)
            case .colorTile(let color, _, _):
                return color.opacity(0.35)
            }
        } else {
            return Color.secondary.opacity(0.15)
        }
    }

    @ViewBuilder
    private var tileContentView: some View {
        if tile.isMatched {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.green)
        } else if tile.isFaceUp {
            switch tile.content {
            case .duck:
                VStack(spacing: 4) {
                    Image(systemName: "duck.fill")
                        .font(.system(size: 22, weight: .bold))
                    Text("DUCK")
                        .font(.caption2)
                        .fontWeight(.bold)
                }
                .foregroundStyle(.orange)

            case .colorTile(_, let symbol, _):
                Text(symbol)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
            }
        } else {
            Image(systemName: "questionmark")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.secondary)
        }
    }
}
