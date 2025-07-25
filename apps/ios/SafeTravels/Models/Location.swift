//
//  Location.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 23/07/2025.
//

import Foundation
import SwiftData
import CoreLocation

@Model
final class Location {
    var latitude: Double
    var longitute: Double
    var altitude: Double
    var timestamp: Date

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitute)
    }

    init(latitude: Double, longitute: Double, altitude: Double, timestamp: Date) {
        self.latitude = latitude
        self.longitute = longitute
        self.altitude = altitude
        self.timestamp = timestamp
    }

    init(polarstepsTrackingLocation location: PolarstepsTrackingLocation) {
        self.latitude = location.latitude
        self.longitute = location.longitude
        self.altitude = 0
        self.timestamp = Date(timeIntervalSince1970: location.timestamp)
    }

    init(polarstepsLocation location: PolarstepsLocation, timestamp: Date) {
        self.latitude = location.latitude
        self.longitute = location.longitude
        self.timestamp = timestamp
        self.altitude = 0
    }

    static let example = Location(latitude: 52.0676294, longitute: 4.3464126, altitude: 0, timestamp: .now)
}
