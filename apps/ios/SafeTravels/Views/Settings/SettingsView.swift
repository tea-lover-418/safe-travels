//
//  SettingsView.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 23/07/2025.
//

import FactoryKit
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) var context
    @InjectedObservable(\.credentialManager) var credentialManager
    @InjectedObservable(\.locationManager) var locationManager
    @State var locationTrackingEnabled = true

    var body: some View {
        NavigationStack {
            List {
                Section("Server configuration") {
                    NavigationLink(destination: ServerConfigurationView()) {
                        LabeledContent("Server") {
                            if let serverURL = credentialManager.serverURL {
                                Text(serverURL.host()!)
                            } else {
                                Text("Not set")
                            }
                        }
                    }
                }

                Section("Automatic tracking") {
                    Toggle("Automatic location tracking", isOn: $locationManager.isLocationTrackingEnabled)
                }

                Section("Privacy and data") {
                    NavigationLink("Import data", destination: ImportView())
                    NavigationLink("Export data", destination: ExportView())
                    Button("Delete data", role: .destructive) {}
                }

                #if DEBUG
                Section("Debug settings") {
                    Button("Import sample data", action: importSampleData)
                    Button("Log current location") {
                        locationManager.logCurrentLocation()
                    }
                }
                #endif
            }
            .navigationTitle("Settings")
        }
    }

    func importSampleData() {
        do {
            // Polarsteps import
            let locationsURL = Bundle.main.url(forResource: "locations", withExtension: "json")!
            let tripURL = Bundle.main.url(forResource: "trip", withExtension: "json")!
            let importer = PolarstepsImporter()
            try importer.import(locationsFromURL: locationsURL, tripFromURL: tripURL, into: context)
            
            try context.save()
        } catch {
            print(error)
        }
    }
}

#Preview {
    SettingsView()
}
