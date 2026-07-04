//
//  LocationManager.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 03/07/26.
//

import Foundation
import CoreLocation

enum RegionPurpose: String {
    case departure
    case destination
}

struct RegionIdentifier {
    let purpose: RegionPurpose
    let stationName: String
    let targetDestination: String?
    
    // Memberwise initializer
    init(purpose: RegionPurpose, stationName: String, targetDestination: String? = nil) {
        self.purpose = purpose
        self.stationName = stationName
        self.targetDestination = targetDestination
    }
    
    var stringValue: String {
        if let dest = targetDestination {
            return "\(purpose.rawValue)|\(stationName)|\(dest)"
        }
        return "\(purpose.rawValue)|\(stationName)"
    }
    
    // Failable initializer from string
    init?(stringValue: String) {
        let parts = stringValue.split(separator: "|")
        guard parts.count >= 2,
              let purpose = RegionPurpose(rawValue: String(parts[0])) else {
            return nil
        }
        self.purpose = purpose
        self.stationName = String(parts[1])
        if parts.count == 3 {
            self.targetDestination = String(parts[2])
        } else {
            self.targetDestination = nil
        }
    }
}

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {

    // Singleton instance for easy background access
    static let shared = LocationManager()
    
    // The underlying CoreLocation manager
    private let manager = CLLocationManager()

    // Properties that your Views can observe
    var userLocation: CLLocation?
    var authorizationStatus: CLAuthorizationStatus
    
    var isMonitoringRoute: Bool = false
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
        
        let identifier = RegionIdentifier(purpose: .destination, stationName: destination.name).stringValue
        let region = CLCircularRegion(
            center: destination.coordinate,
            radius: radius,
            identifier: identifier
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
    
    // MARK: - Testing / Departure
    
    func startMonitoringDeparture(stationName: String, destinationName: String, radius: CLLocationDistance, coordinate: CLLocationCoordinate2D) {
        guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else {
            print("Geofencing is not supported on this device!")
            return
        }
        
        let identifier = RegionIdentifier(purpose: .departure, stationName: stationName, targetDestination: destinationName).stringValue
        let region = CLCircularRegion(center: coordinate, radius: radius, identifier: identifier)
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        manager.startMonitoring(for: region)
        // Request the state immediately to see if we are already inside
        manager.requestState(for: region)
        print("Started monitoring DEPARTURE region around \(stationName) with radius \(radius) meters.")
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
        print("Did Enter Region: \(region.identifier)")
        
        // Logika untuk stasiun:
        handleRegionEvent(region: region, state: .inside)
    }
    
    // Triggered when we request the state (e.g. immediately after registering)
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        print("Did Determine State for \(region.identifier): \(state == .inside ? "Inside" : "Outside/Unknown")")
        
        if state == .inside {
            handleRegionEvent(region: region, state: .inside)
        }
    }
    
    private func handleRegionEvent(region: CLRegion, state: CLRegionState) {
        // Prevent double triggering if already monitoring route
        guard state == .inside else { return }
        
        // Decode the structured identifier
        guard let regionId = RegionIdentifier(stringValue: region.identifier) else {
            print("Unknown region format: \(region.identifier)")
            return
        }
        
        switch regionId.purpose {
        case .departure:
            if !self.isMonitoringRoute {
                print("User is at departure station. Start alarm monitoring state.")
                // Synchronously set to true to prevent double triggers if called rapidly
                self.isMonitoringRoute = true
                
                let destName = regionId.targetDestination ?? "Destination"
                AlarmTriggerManager.shared.triggerDepartureNotification(for: destName)
            }
            
        case .destination:
            print("User near destination station! Trigger alarm!")
            AlarmTriggerManager.shared.triggerAlarm(for: regionId.stationName)
        }
    }

    // Handle errors (important for debugging)
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager failed with error: \(error.localizedDescription)")
        self.lastError = error.localizedDescription
    }
}
