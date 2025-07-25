//
//  SafeTravelsApp.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 09/07/2025.
//

import FactoryKit
import SwiftUI
import SwiftData

@main
struct SafeTravelsApp: App {
    @UIApplicationDelegateAdaptor var appDelegate: SafeTravelsAppDelegate

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(Container.shared.sharedModelContainer())
    }
}
