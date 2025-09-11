//
//  MainView.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 23/07/2025.
//

import SwiftUI

struct MainView: View {
    @AppStorage("isPresentingOnboarding") var isPresentingOnboarding = true

    var body: some View {
        TabView {
            Tab("Map", systemImage: "map") {
                MapView()
            }
            Tab("Posts", systemImage: "book.pages") {
                PostsView()
            }
            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
        .sheet(isPresented: $isPresentingOnboarding) {
            OnboardingView()
                .padding(.top)
                .interactiveDismissDisabled()
        }
    }
}

#Preview(traits: .modifier(SampleData())) {
    MainView()
}
