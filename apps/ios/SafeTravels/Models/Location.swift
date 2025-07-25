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
    var longitude: Double
    var altitude: Double
    var timestamp: Date

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(clLocation location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.altitude = location.altitude
        self.timestamp = location.timestamp
    }

    init(latitude: Double, longitude: Double, altitude: Double = 0, timestamp: TimeInterval) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.timestamp = Date(timeIntervalSince1970: timestamp)
    }

    init(latitude: Double, longitude: Double, altitude: Double = 0, timestamp: Date) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.timestamp = timestamp
    }

    init(polarstepsTrackingLocation location: PolarstepsTrackingLocation) {
        self.latitude = location.latitude
        self.longitude = location.longitude
        self.altitude = 0
        self.timestamp = Date(timeIntervalSince1970: location.timestamp)
    }

    init(polarstepsLocation location: PolarstepsLocation, timestamp: Date) {
        self.latitude = location.latitude
        self.longitude = location.longitude
        self.timestamp = timestamp
        self.altitude = 0
    }

    static let example = Location(latitude: 52.0676294, longitude: 4.3464126, altitude: 0, timestamp: .now)
}
