//
//  LocationDebugView.swift
//  Bangunin
//

import SwiftUI
import CoreLocation

struct LocationDebugView: View {
    @State private var viewModel = LocationDebugViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Authorization Status")) {
                    HStack {
                        Text("Status")
                        Spacer()
                        Text(viewModel.authorizationStatusString)
                            .foregroundColor(viewModel.authorizationStatusColor)
                            .bold()
                    }
                    
                    if viewModel.locationManager.authorizationStatus == .notDetermined {
                        Button("Request 'Always' Permission") {
                            viewModel.requestPermission()
                        }
                    }
                }
                
                Section(header: Text("Current Location")) {
                    if let location = viewModel.locationManager.userLocation {
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
                    
                    if let timestamp = viewModel.locationManager.lastUpdateTimestamp {
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
                        Text(viewModel.locationManager.isMonitoringRoute ? "ACTIVE" : "IDLE")
                            .foregroundColor(viewModel.locationManager.isMonitoringRoute ? .green : .gray)
                            .bold()
                    }
                    
                    Button("Test: Enter Departure Station") {
                        viewModel.startMockGeofence()
                    }
                    .foregroundColor(.blue)
                    
                    
                    Button("Reset Alarm State & Geofences") {
                        viewModel.resetAlarmState()
                    }
                    .foregroundColor(.red)
                }
                
                Section(header: Text("System State")) {
                    if let error = viewModel.locationManager.lastError {
                        VStack(alignment: .leading) {
                            Text("Error")
                                .bold()
                                .foregroundColor(.red)
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    } else if viewModel.locationManager.userLocation != nil {
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
                        viewModel.startTracking()
                    }
                    .foregroundColor(.blue)
                    
                    Button("Stop Tracking") {
                        viewModel.stopTracking()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Location Debug")
        }
    }
}

#Preview {
    LocationDebugView()
}
