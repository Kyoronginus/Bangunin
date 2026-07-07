//
//  LocationDebugViewModel.swift
//  Bangunin
//

import SwiftUI
import CoreLocation

@Observable
class LocationDebugViewModel {
    var locationManager = LocationManager.shared
    
    var authorizationStatusString: String {
        switch locationManager.authorizationStatus {
        case .notDetermined: return "Not Determined"
        case .restricted: return "Restricted"
        case .denied: return "Denied"
        case .authorizedAlways: return "Always"
        case .authorizedWhenInUse: return "When In Use"
        @unknown default: return "Unknown"
        }
    }
    
    var authorizationStatusColor: Color {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse: return .green
        case .denied, .restricted: return .red
        default: return .orange
        }
    }
    
    func requestPermission() {
        locationManager.requestPermission()
    }
    
    func startMockGeofence() {
            if let loc = locationManager.userLocation {
                AlarmTriggerManager.shared.requestPermissions()
                
                locationManager.startMonitoringDeparture(
                    alarmID: UUID().uuidString,
                    stationName: "MockStation",
                    destinationName: "DestinationMockStation",
                    radius: 100,
                    coordinate: loc.coordinate
                )
            } else {
                print("No location available for mock geofence")
            }
        }
    
    func resetAlarmState() {
        locationManager.stopMonitoringAllRegions()
        locationManager.isMonitoringRoute = false
    }
    
    func startTracking() {
        locationManager.startTracking()
    }
    
    func stopTracking() {
        locationManager.stopTracking()
    }
}
