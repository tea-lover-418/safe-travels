//
//  PreviewSampleData.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 23/07/2025.
//

import Foundation
import SwiftUI
import SwiftData

struct SampleData: PreviewModifier {
    static func makeSharedContext() throws -> ModelContainer {
        let schema = Schema([Trip.self, Post.self, Location.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        let context = ModelContext(container)
        let importer = PolarstepsImporter()

        let locationsURL = Bundle.main.url(forResource: "locations", withExtension: "json")!
        let tripURL = Bundle.main.url(forResource: "trip", withExtension: "json")!
        try importer.import(locationsFromURL: locationsURL, tripFromURL: tripURL, into: context)
        try context.save()

        return container
    }

    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
 }
