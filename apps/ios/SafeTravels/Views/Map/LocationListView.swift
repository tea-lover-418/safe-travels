//
//  LocationListView.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 25/07/2025.
//

import SwiftUI

struct LocationListView: View {
    var locations: [Location]

    var sections: [LocationSection] {
        let dict = Dictionary(grouping: locations, by: { location in
            location.timestamp.formatted(date: .numeric, time: .omitted)
        })
        return dict.map { key, locations in
            let locations = locations.sorted(by: { $0.timestamp < $1.timestamp })
            let firstLocation = locations.first!
            let title = firstLocation.timestamp.formatted(date: .complete, time: .omitted)
            return LocationSection(id: key, timestamp: firstLocation.timestamp, title: title, locations: locations)
        }
    }

    var body: some View {
        List {
            ForEach(sections) { section in
                Section(section.title) {
                    ForEach(section.locations) { location in
                        LocationCell(location: location)
                    }
                }
            }
        }
    }
}

struct LocationSection: Identifiable {
    let id: String
    let timestamp: Date
    let title: String
    let locations: [Location]
}

struct LocationCell: View {
    var location: Location

    var body: some View {
        Text(verbatim: "\(location.latitude),\(location.longitude)")
    }
}

#Preview() {
    let locations: [Location] = [
        Location(
            timestamp: Date(timeIntervalSince1970: 1747054226),
            latitude: 50.60983378444855,
            longitude: 5.6122473534248885
        ),
        Location(
            timestamp: Date(timeIntervalSince1970: 1747054579),
            latitude: 50.59807296847049,
            longitude: 5.591885615145407
        ),
        Location(
            timestamp: Date(timeIntervalSince1970: 1747055065),
            latitude: 50.57662191805483,
            longitude: 5.60343545862064
        ),
        Location(
            timestamp: Date(timeIntervalSince1970: 1747055394),
            latitude: 50.57091996078432,
            longitude: 5.58613194153233
        ),
        Location(
            timestamp: Date(timeIntervalSince1970: 1747055693),
            latitude: 50.55768676511364,
            longitude: 5.575405749607888
        ),
        Location(
            timestamp: Date(timeIntervalSince1970: 1747056033),
            latitude: 50.54368183487146,
            longitude: 5.589546728884419
        )
    ]
    NavigationStack {
        LocationListView(locations: locations)
    }
}
