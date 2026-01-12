//
//  MainMenuView.swift
//  doDotDuck
//
//  Created by cobsccomp24.2p-021 on 2026-01-12.
//

import SwiftUI

struct MainMenuView: View {
    @State private var showQuitHelp = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Spacer()

                VStack(spacing: 8) {
                    Text("doDotDuck")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                    Text("Match the pairs. One mistake resets!")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                Spacer()

                NavigationLink {
                    DifficultyView()
                } label: {
                    Label("Start Game", systemImage: "play.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Button {
                    showQuitHelp = true
                } label: {
                    Label("Quit Game", systemImage: "xmark.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)

                Spacer()
            }
            .padding()
            .navigationTitle("Menu")
            .sheet(isPresented: $showQuitHelp) {
                QuitHelpSheet()
            }
        }
    }
}

struct QuitHelpSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                Image(systemName: "hand.raised.fill")
                    .font(.system(size: 44))
                    .padding(.top, 10)

                Text("iPhone apps don’t have a real “Quit” button.")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)

                Text("""
To quit the game:
1) Swipe up from the bottom (Home gesture).
2) Open the App Switcher.
3) Swipe up on doDotDuck to close it.
""")
                .font(.body)
                .foregroundStyle(.secondary)

                Spacer()
            }
            .padding()
            .navigationTitle("Quit Help")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
