//
//  UserDefaults+SafeTravel.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 22/08/2025.
//

import Foundation

enum UserDefaultsKey: String {
    case isLocationTrackingEnabled
}

extension UserDefaults {
    /// Global preference that lets the user enable/disable location tracking.
    var isLocationTrackingEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKey.isLocationTrackingEnabled.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.isLocationTrackingEnabled.rawValue)
        }
    }
}
