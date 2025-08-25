//
//  Location.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 23/07/2025.
//

import Foundation
import SwiftData
import CoreLocation

enum LocationSource: String, Codable {
    case standard, significant, visit
}

@Model
final class Location {
    var timestamp: Date
    var latitude: Double
    var longitude: Double
    var altitude: Double
    var horizontalAccuracy: Double?
    var speed: Double?
    var course: Double?
    var source: LocationSource?

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(clLocation location: CLLocation, source: LocationSource?) {
        self.timestamp = location.timestamp
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.altitude = location.altitude
        self.horizontalAccuracy = location.horizontalAccuracy
        self.speed = (location.speed >= 0) ? location.speed : nil
        self.course = (location.course >= 0) ? location.course : nil
        self.source = source
    }

    init(timestamp: Date, latitude: Double, longitude: Double, altitude: Double = 0, horizontalAccuracy: Double? = nil, speed: Double? = nil, course: Double? = nil, source: LocationSource? = nil) {
        self.timestamp = timestamp
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.horizontalAccuracy = horizontalAccuracy
        self.speed = speed
        self.course = course
        self.source = source
    }

    init(polarstepsTrackingLocation location: PolarstepsTrackingLocation) {
        self.latitude = location.latitude
        self.longitude = location.longitude
        self.altitude = 0
        self.timestamp = Date(timeIntervalSince1970: location.timestamp)
        self.horizontalAccuracy = nil
        self.speed = nil
        self.course = nil
        self.source = nil
    }

    init(polarstepsLocation location: PolarstepsLocation, timestamp: Date) {
        self.latitude = location.latitude
        self.longitude = location.longitude
        self.altitude = 0
        self.timestamp = timestamp
        self.horizontalAccuracy = nil
        self.speed = nil
        self.course = nil
        self.source = nil
    }

    static let example = Location(
        timestamp: .now,
        latitude: 52.0676294,
        longitude: 4.3464126,
        altitude: 0,
        horizontalAccuracy: 0
    )
}
