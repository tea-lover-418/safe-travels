//
//  OnboardingView.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 25/07/2025.
//

import SwiftUI

struct OnboardingView: View {
    @State var selectedPage: OnboardingStep = .welcome
    @Environment(\.dismiss) var dismiss

    enum OnboardingStep: Hashable {
        case welcome
        case locationPermission
        case setupServer
        case finished
    }

    var body: some View {
        TabView(selection: $selectedPage) {
            OnboardingWelcomeView {
                selectedPage = .setupServer
            }
            .tag(OnboardingStep.welcome)

            OnboardingServerSetupView {
                selectedPage = .locationPermission
            }
            .tag(OnboardingStep.setupServer)

            OnboardingLocationPermissionView {
                selectedPage = .finished
            }
            .tag(OnboardingStep.locationPermission)

            OnboardingFinishedView {
                dismiss()
            }
            .tag(OnboardingStep.finished)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(.default, value: selectedPage)
    }
}

#Preview {
    OnboardingView()
}
