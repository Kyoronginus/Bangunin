//
//  LocationDebugView.swift
//  Bangunin
//

import SwiftUI
import CoreLocation

struct LocationDebugView: View {
    // Observing the singleton directly
    @State private var locationManager = LocationManager.shared
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Authorization Status")) {
                    HStack {
                        Text("Status")
                        Spacer()
                        Text(statusString(for: locationManager.authorizationStatus))
                            .foregroundColor(statusColor(for: locationManager.authorizationStatus))
                            .bold()
                    }
                    
                    if locationManager.authorizationStatus == .notDetermined {
                        Button("Request 'Always' Permission") {
                            locationManager.requestPermission()
                        }
                    }
                }
                
                Section(header: Text("Current Location")) {
                    if let location = locationManager.userLocation {
                        HStack {
                            Text("Latitude")
                            Spacer()
                            Text(String(format: "%.6f", location.coordinate.latitude))
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("Longitude")
                            Spacer()
                            Text(String(format: "%.6f", location.coordinate.longitude))
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            Text("Accuracy")
                            Spacer()
                            Text(String(format: "%.1f meters", location.horizontalAccuracy))
                                .foregroundColor(.secondary)
                        }
                    } else {
                        Text("No location data yet...")
                            .foregroundColor(.gray)
                            .italic()
                    }
                    
                    if let timestamp = locationManager.lastUpdateTimestamp {
                        HStack {
                            Text("Last Updated")
                            Spacer()
                            Text(timestamp, style: .time)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section(header: Text("Alarm & Monitoring State")) {
                    HStack {
                        Text("Monitoring Route")
                        Spacer()
                        Text(locationManager.isMonitoringRoute ? "ACTIVE" : "IDLE")
                            .foregroundColor(locationManager.isMonitoringRoute ? .green : .gray)
                            .bold()
                    }
                    
                    Button("Test: Enter Departure Station") {
                        if let loc = locationManager.userLocation {
                            // Request Notification permission just in case
                            AlarmTriggerManager.shared.requestPermissions()
                            
                            // Start a mock geofence at current location with 100m radius
                            locationManager.startMonitoringDeparture(stationName: "MockStation", destinationName: "DestinationMockStation", radius: 100, coordinate: loc.coordinate)
                        } else {
                            print("No location available for mock geofence")
                        }
                    }
                    .foregroundColor(.blue)
                    
                    
                    Button("Reset Alarm State & Geofences") {
                        locationManager.stopMonitoringAllRegions()
                        locationManager.isMonitoringRoute = false
                    }
                    .foregroundColor(.red)
                }
                
                Section(header: Text("System State")) {
                    if let error = locationManager.lastError {
                        VStack(alignment: .leading) {
                            Text("Error")
                                .bold()
                                .foregroundColor(.red)
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    } else if locationManager.userLocation != nil {
                        HStack {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.green)
                            Text("Connected & Receiving Updates")
                        }
                    } else {
                        HStack {
                            Image(systemName: "circle.fill")
                                .foregroundColor(.orange)
                            Text("Waiting for GPS...")
                        }
                    }
                    
                    Button("Start Tracking") {
                        locationManager.startTracking()
                    }
                    .foregroundColor(.blue)
                    
                    Button("Stop Tracking") {
                        locationManager.stopTracking()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Location Debug")
        }
    }
    
    private func statusString(for status: CLAuthorizationStatus) -> String {
        switch status {
        case .notDetermined: return "Not Determined"
        case .restricted: return "Restricted"
        case .denied: return "Denied"
        case .authorizedAlways: return "Always"
        case .authorizedWhenInUse: return "When In Use"
        @unknown default: return "Unknown"
        }
    }
    
    private func statusColor(for status: CLAuthorizationStatus) -> Color {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse: return .green
        case .denied, .restricted: return .red
        default: return .orange
        }
    }
}

#Preview {
    LocationDebugView()
}
