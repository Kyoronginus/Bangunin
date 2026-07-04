//
//  LocationManager.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 03/07/26.
//

import Foundation
import CoreLocation

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {

    // Singleton instance for easy background access
    static let shared = LocationManager()
    
    // The underlying CoreLocation manager
    private let manager = CLLocationManager()

    // Properties that your Views can observe
    var userLocation: CLLocation?
    var authorizationStatus: CLAuthorizationStatus
    var lastUpdateTimestamp: Date?
    var lastError: String?

    private override init() {
        // Initialize the starting authorization status
        self.authorizationStatus = manager.authorizationStatus
        super.init()

        // Set the delegate so we can receive location updates
        manager.delegate = self

        // Optimize battery by setting the appropriate accuracy
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Safety check to prevent NSInternalInconsistencyException if capability is missing
        if let modes = Bundle.main.object(forInfoDictionaryKey: "UIBackgroundModes") as? [String], modes.contains("location") {
            manager.allowsBackgroundLocationUpdates = true
        } else {
            print("WARNING: Missing 'location' in UIBackgroundModes capability. Background updates disabled to prevent crash.")
        }
        
        manager.pausesLocationUpdatesAutomatically = false
    }

    // MARK: - Intents

    func requestPermission() {
        // We need always authorization to monitor regions in the background while sleeping
        manager.requestAlwaysAuthorization()
    }

    func startTracking() {
        manager.startUpdatingLocation()
    }

    func stopTracking() {
        manager.stopUpdatingLocation()
    }

    func startMonitoring(destination: Station, radius: CLLocationDistance) {
        guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else {
            print("Geofencing is not supported on this device!")
            return
        }
        
        let region = CLCircularRegion(
            center: destination.coordinate,
            radius: radius,
            identifier: destination.name
        )
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        manager.startMonitoring(for: region)
        print("Started monitoring region around \(destination.name) with radius \(radius) meters.")
    }

    func stopMonitoringAllRegions() {
        for region in manager.monitoredRegions {
            manager.stopMonitoring(for: region)
        }
    }

    // MARK: - CLLocationManagerDelegate

    // This is called automatically whenever the user's location changes
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        self.userLocation = latestLocation
        self.lastUpdateTimestamp = Date()
        self.lastError = nil // clear error on successful update
    }

    // This is called automatically whenever the user changes the location permission
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus

        // If the user granted permission, start tracking immediately
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            startTracking()
        }
    }

    // Triggered when the user enters the geofence radius
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let circularRegion = region as? CLCircularRegion {
            print("Entered region: \(circularRegion.identifier)")
            // Trigger the alarm!
            AlarmTriggerManager.shared.triggerAlarm(for: circularRegion.identifier)
            
            // Stop monitoring after triggering
            manager.stopMonitoring(for: region)
        }
    }

    // Handle errors (important for debugging)
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager failed with error: \(error.localizedDescription)")
        self.lastError = error.localizedDescription
    }
}
