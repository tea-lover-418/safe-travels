//
//  LocationManager.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 25/07/2025.
//

import Foundation
import CoreLocation
import SwiftData
import os.log

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager: CLLocationManager
    private let modelContext: ModelContext

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "LocationManager")

    private var permissionContinuation: UnsafeContinuation<CLAuthorizationStatus, Never>?

    var authorizationStatus: CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }

    var isLocationTrackingEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isLocationTrackingEnabled")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isLocationTrackingEnabled")
            if newValue {
                startLocationTracking()
            } else {
                stopLocationTracking()
            }
        }
    }

    init(locationManager: CLLocationManager, modelContext: ModelContext) {
        self.locationManager = locationManager
        self.modelContext = modelContext
        super.init()
        locationManager.delegate = self
        // locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.activityType = .otherNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.distanceFilter = 100
        // locationManager.pausesLocationUpdatesAutomatically = true
    }

    func requestAuthorization() async -> CLAuthorizationStatus {
        return await withUnsafeContinuation { continuation in
            permissionContinuation = continuation
            locationManager.requestAlwaysAuthorization()
        }
    }

    func startLocationTracking() {
        locationManager.startUpdatingLocation()
    }

    func stopLocationTracking() {
        locationManager.stopUpdatingLocation()
    }

    func start() {
        if isLocationTrackingEnabled {
            startLocationTracking()
        }
    }

    func logCurrentLocation() {
        locationManager.requestLocation()
    }

    // MARK: CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        permissionContinuation?.resume(returning: manager.authorizationStatus)
        switch manager.authorizationStatus {
        case .notDetermined:
            logger.info("Location authorization changed to: not determined")
        case .restricted:
            logger.info("Location authorization changed to: restricted")
        case .denied:
            logger.info("Location authorization changed to: denied")
        case .authorizedAlways:
            logger.info("Location authorization changed to: authorized always")
        case .authorizedWhenInUse:
            logger.info("Location authorization changed to: authorized when in use")
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        do {
            for clLocation in locations {
                let location = Location(clLocation: clLocation)
                modelContext.insert(location)
            }
            logger.info("Logged \(locations.count) new locations")
            try modelContext.save()
        } catch {
            logger.error("Error inserting new locations: \(error)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        logger.error("Location manager did fail with error: \(error)")
    }
}

/// Object for requesting the current location asynchronously.
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
