//
//  Container.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 25/07/2025.
//

import FactoryKit
import SwiftData
import CoreLocation

extension Container {
    var sharedModelContainer: Factory<ModelContainer> {
        Factory(self) {
            let schema = Schema([Trip.self, Post.self, Location.self])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }.singleton
    }

    var credentialManager: Factory<CredentialManager> {
        Factory(self) {
            CredentialManager()
        }.singleton
    }

    var apiClient: Factory<APIClient> {
        Factory(self) {
            APIClient(credentialManager: self.credentialManager())
        }
    }

    private var clLocationManager: Factory<CLLocationManager> {
        Factory(self) {
            CLLocationManager()
        }.singleton
    }

    var locationManager: Factory<LocationManager> {
        Factory(self) {
            LocationManager(
                locationManager: self.clLocationManager(),
                modelContext: ModelContext(self.sharedModelContainer())
            )
        }.singleton
    }
}
