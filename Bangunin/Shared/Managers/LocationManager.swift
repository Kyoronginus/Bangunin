//
//  LocationManager.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 03/07/26.
//

import Foundation
import CoreLocation

// @Observable allows SwiftUI views to automatically update when properties change
@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {

    // The underlying CoreLocation manager
    private let manager = CLLocationManager()

    // Properties that your Views can observe
    var userLocation: CLLocation?
    var authorizationStatus: CLAuthorizationStatus

    override init() {
        // Initialize the starting authorization status
        self.authorizationStatus = manager.authorizationStatus
        super.init()

        // Set the delegate so we can receive location updates
        manager.delegate = self

        // Optimize battery by setting the appropriate accuracy
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // MARK: - Intents

    func requestPermission() {
        // Request permission to use location while the app is open
        manager.requestWhenInUseAuthorization()
    }

    func startTracking() {
        manager.startUpdatingLocation()
    }

    func stopTracking() {
        manager.stopUpdatingLocation()
    }

    
    // MARK: - CLLocationManagerDelegate

    // This is called automatically whenever the user's location changes
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        self.userLocation = latestLocation

        // Example: Print coordinates for debugging
        print("Updated location: \(latestLocation.coordinate.latitude), \(latestLocation.coordinate.longitude)")
    }

    // This is called automatically whenever the user changes the location permission (e.g. from Denied to Allowed)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus

        // If the user granted permission, start tracking immediately
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            startTracking()
        }
    }

    // Handle errors (important for debugging)
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager failed with error: \(error.localizedDescription)")
    }
}
