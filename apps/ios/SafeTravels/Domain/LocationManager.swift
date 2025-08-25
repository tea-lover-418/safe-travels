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

    var isRecording = false {
        didSet { configureMode() }
    }

    init(locationManager: CLLocationManager, modelContext: ModelContext) {
        self.locationManager = locationManager
        self.modelContext = modelContext
        super.init()
        locationManager.delegate = self

        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.activityType = .otherNavigation
    }

    func requestAuthorization() async -> CLAuthorizationStatus {
        return await withUnsafeContinuation { continuation in
            permissionContinuation = continuation
            locationManager.requestAlwaysAuthorization()
        }
    }

    func enableLocationTracking() {
        logger.info("Location tracking enabled")
        UserDefaults.standard.isLocationTrackingEnabled = true
        start()
    }

    func disableLocationTracking() {
        logger.info("Location tracking disabled")
        UserDefaults.standard.isLocationTrackingEnabled = false
        stop()
    }

    /// Start location updates
    func start() {
        logger.info("Starting location updates")

        // Start the cheap, always-on modes
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            locationManager.startMonitoringSignificantLocationChanges()
        }
        locationManager.startMonitoringVisits()
        configureMode()
    }

    /// Stop location updates
    func stop() {
        logger.info("Stopping location updates")

        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.stopMonitoringVisits()
    }

    private func configureMode() {
        if isRecording {
            // “Active” mode: standard updates, moderate accuracy & distance filter
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter = 50 // meters; tune 50–100 for battery
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
            // Significant+Visits remain active from start()
        }
    }

    func logCurrentLocation() {
        locationManager.requestLocation()
    }

    private func save(locations clLocations: [CLLocation], source: LocationSource) {
        for clLocation in clLocations {
            let location = Location(clLocation: clLocation, source: source)
            modelContext.insert(location)
        }

        do {
            try modelContext.save()
            logger.info("Logged \(clLocations.count) new locations")
        } catch {
            logger.error("Error saving location: \(error)")
        }
    }

    private func save(visit: CLVisit) {
        let coord = visit.departureDate == .distantFuture ? visit.arrivalDate : visit.departureDate
        let location = Location(
            timestamp: coord,
            latitude: visit.coordinate.latitude,
            longitude: visit.coordinate.longitude
        )
        modelContext.insert(location)
        do {
            try modelContext.save()
            logger.info("Logged new visit")
        } catch {
            logger.error("Error saving visit: \(error)")
        }
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
        save(locations: locations, source: .standard)
    }

    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        save(visit: visit)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        logger.error("Location manager did fail with error: \(error)")
    }
}
