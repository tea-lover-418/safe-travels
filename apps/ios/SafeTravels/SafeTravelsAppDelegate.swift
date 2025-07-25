//
//  SafeTravelsAppDelegate.swift
//  SafeTravels
//
//  Created by Mathijs Bernson on 25/07/2025.
//

import FactoryKit
import UIKit

class SafeTravelsAppDelegate: NSObject, UIApplicationDelegate {
    @Injected(\.locationManager) private var locationManager

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        locationManager.start()
        return true
    }
}
