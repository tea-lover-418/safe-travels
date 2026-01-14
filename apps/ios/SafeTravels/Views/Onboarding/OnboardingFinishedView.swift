//
//  OnboardingFinishedView.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 25/07/2025.
//

import SwiftUI

struct OnboardingFinishedView: View {
    let action: () -> Void

    var body: some View {
        OnboardingPage("Setup complete") {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.green)
                .padding(.bottom, 16)
            VStack(alignment: .leading, spacing: 16) {
                Text("You can now start using SafeTravels to track your journeys and share them with others.")
                Text("If you want to change your settings later, you can do so in the Settings tab.")
            }
        } actions: {
            Button("Done") {
                action()
            }
        }
    }
}

#Preview {
    OnboardingFinishedView(action: {})
}
