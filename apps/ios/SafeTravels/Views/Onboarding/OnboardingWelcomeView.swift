//
//  OnboardingWelcomeView.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 25/07/2025.
//

import SwiftUI

struct OnboardingWelcomeView: View {
    let action: () -> Void

    var body: some View {
        OnboardingPage {
                Text("Welcome to\nSafeTravels")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)

                Text("The privacy friendly travel diary, for self hosting.")
                    .fontWeight(.medium)
        } content: {
            VStack(spacing: 24) {
                OnboardingWelcomeCell(
                    systemImageName: "location.north.fill",
                    title: "Location tracking",
                    description: "Automatically track your location, showing your journey on the map."
                )
                .tint(.green)

                OnboardingWelcomeCell(
                    systemImageName: "book.pages.fill",
                    title: "Journaling",
                    description: "Write updates about your travels for your friends and loved ones."
                )
                .tint(.brown)

                OnboardingWelcomeCell(
                    systemImageName: "hand.raised.fill",
                    title: "Self-hosted",
                    description: "You are always in control of your data."
                )
                .tint(.blue)
            }
            .padding(.top, 24)
        } actions: {
            Button("Continue") {
                action()
            }
        }
    }
}

struct OnboardingWelcomeCell: View {
    let systemImageName: String
    let title: LocalizedStringKey
    let description: LocalizedStringKey

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: systemImageName)
                .font(.largeTitle)
                .foregroundStyle(.tint)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    OnboardingWelcomeView(action: {})
}
