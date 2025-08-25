//
//  LocationRequester.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 22/08/2025.
//

import Foundation
import CoreLocation

/// A helper object that lets you request the current location asynchronously.
class LocationRequester: NSObject, CLLocationManagerDelegate {
    private let locationManager: CLLocationManager
    private var continuation: UnsafeContinuation<CLLocation?, Error>?

    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }

    func requestCurrentLocation() async throws -> CLLocation? {
        guard locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse else {
            return nil
        }
        return try await withUnsafeThrowingContinuation { continuation in
            self.continuation = continuation
            locationManager.delegate = self
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        continuation?.resume(returning: locations.first)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
    }
}
