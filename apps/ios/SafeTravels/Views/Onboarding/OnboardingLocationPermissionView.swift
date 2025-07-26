//
//  OnboardingLocationPermissionView.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 25/07/2025.
//

import FactoryKit
import SwiftUI

struct OnboardingLocationPermissionView: View {
    @Injected(\.locationManager) var locationManager

    let action: () -> Void

    var body: some View {
        OnboardingPage("Location tracking") {
            VStack(alignment: .leading, spacing: 16) {
                Text("Would you like SafeTravel to automatically track your location?")
                Text("Your journey will automatically be visible on your SafeTravel server, if you have configured one.")
            }
        } actions: {
            AsyncButton("Enable location tracking") {
                if locationManager.authorizationStatus == .notDetermined {
                    let _ = await locationManager.requestAuthorization()
                }
                locationManager.isLocationTrackingEnabled = true
                action()
            }

            Button("Set up later") {
                locationManager.isLocationTrackingEnabled = false
                action()
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    OnboardingLocationPermissionView(action: {})
}
