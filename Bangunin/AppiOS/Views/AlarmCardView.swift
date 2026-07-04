//
//  AlarmCardView.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 02/07/26.
//

import SwiftUI

struct AlarmCardView: View {

    @Bindable var alarm: Alarm

    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(alarm.label)
                    .foregroundStyle(.gray)
                HStack {
                    Text(alarm.departureStation)
                        .bold()
                        .font(.title)
                    Image(systemName: "arrow.right")
                    Text(alarm.destinationStation)
                        .bold()
                        .font(.title)
                }
                Text(alarm.repeatStatus)
            }
            Spacer()
            Toggle("", isOn: $alarm.isActive)
                .tint(.green)
                .labelsHidden()
                .offset(y: 20)
                .onChange(of: alarm.isActive) { oldValue, newValue in
                    if newValue {
                        // Alarm turned ON
                        // Find departure and destination stations to start monitoring
                        if let depStation = findStation(name: alarm.departureStation),
                           let destStation = findStation(name: alarm.destinationStation) {
                            
                            LocationManager.shared.startMonitoringDeparture(
                                stationName: depStation.name,
                                destinationName: destStation.name,
                                radius: 100, // Fixed radius for testing/demo
                                coordinate: depStation.coordinate
                            )
                            
                            LocationManager.shared.startMonitoring(
                                destination: destStation,
                                radius: 3000 // 3km for wake up
                            )
                            print("Alarm turned ON, registered geofences.")
                        }
                    } else {
                        // Alarm turned OFF
                        LocationManager.shared.stopMonitoringAllRegions()
                        LocationManager.shared.isMonitoringRoute = false
                        print("Alarm turned OFF, cleared geofences.")
                    }
                }
        }
        .padding()
    }
    
    // Helper to find a station's coordinates by name
    private func findStation(name: String) -> Station? {
        for (_, stations) in routeStations {
            if let found = stations.first(where: { $0.name == name }) {
                return found
            }
        }
        return nil
    }
}
