//
//  DifficultyView.swift
//  doDotDuck
//
//  Created by cobsccomp24.2p-021 on 2026-01-12.
//

import SwiftUI

struct DifficultyView: View {
    var body: some View {
        List {
            Section("Select Difficulty") {
                ForEach(Difficulty.allCases) { level in
                    NavigationLink {
                        GameView(difficulty: level)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(level.title)
                                .font(.headline)
                            Text(level.subtitle)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            Section("Rule") {
                Text("Tap two tiles. If they match, they stay open. If they do not match, the game resets but tile positions stay the same.")
            }

            Section("Why there is a Duck tile") {
                Text("Your grids are 3×3, 5×5, and 7×7. These are odd counts, so we add one special DoDotDuck tile to make the rest pairable.")
            }
        }
        .navigationTitle("Difficulty")
    }
}
