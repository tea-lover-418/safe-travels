//
//  PolarstepsImporter.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 24/07/2025.
//

import Foundation
import SwiftData

struct PolarstepsImporter {
    private let decoder = JSONDecoder()

    func `import`(
        locationsFromURL locationsURL: URL,
        tripFromURL tripURL: URL,
        into context: ModelContext
    ) throws {
        let locationData = try Data(contentsOf: locationsURL)
        let locationsContainer = try decoder.decode(PolarstepsTrackingLocations.self, from: locationData)
        let locations = locationsContainer.locations.map(Location.init(polarstepsTrackingLocation:))
        for location in locations {
            context.insert(location)
        }

        let tripData = try Data(contentsOf: tripURL)
        let trip = try decoder.decode(PolarstepsTrip.self, from: tripData)
        context.insert(Trip(polarstepsTrip: trip, locations: locations))
    }
}
