//
//  SettingsView.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 23/07/2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) var context
    @State var locationTrackingEnabled = true

    var body: some View {
        NavigationStack {
            List {
                Section("Automatic tracking") {
                    Toggle("Automatic location tracking", isOn: $locationTrackingEnabled)
                }

                Section("Privacy and data") {
                    NavigationLink("Import data", destination: ImportView())
                    NavigationLink("Export data", destination: ExportView())
                    Button("Delete data", role: .destructive) {}
                }

                Button("Import sample data", action: importSampleData)
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
