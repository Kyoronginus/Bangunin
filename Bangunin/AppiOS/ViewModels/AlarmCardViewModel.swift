//
//  AlarmCardViewModel.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 05/07/26.
//

import SwiftUI

@Observable
class AlarmCardViewModel {
    var alarm: Alarm
    
    init(alarm: Alarm) {
        self.alarm = alarm
    }
    
    func toggleAlarm(isActive: Bool) {
        alarm.isActive = isActive
        
        if isActive {
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


