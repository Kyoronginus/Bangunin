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
    
    var repeatStatus: String {
        let selected = Set(alarm.repeatOptions)
        let weekdays: Set<RepeatOption> = [.monday, .tuesday, .wednesday, .thursday, .friday]
        let weekends: Set<RepeatOption> = [.saturday, .sunday]

        if selected.isEmpty {
            return "Never"
        } else if selected.count == RepeatOption.allCases.count {
            return "Everyday"
        } else if selected == weekdays {
            return "Every Weekday"
        } else if selected == weekends {
            return "Every Weekend"
        } else {
            return RepeatOption.allCases.filter { selected.contains($0) }
                .map { String($0.rawValue.replacingOccurrences(of: "Every ", with: "").prefix(3)) }
                .joined(separator: ", ")
        }
    }
    
    func toggleAlarm(isActive: Bool) {
        alarm.isActive = isActive
        
        if isActive {
            if let depStation = findStation(name: alarm.departureStation),
               let destStation = findStation(name: alarm.destinationStation) {
                
                LocationManager.shared.startMonitoringDeparture(
                    alarmID: alarm.id.uuidString,
                    stationName: depStation.name,
                    destinationName: destStation.name,
                    radius: 100, // Fixed radius for testing/demo
                    coordinate: depStation.coordinate
                )
                
                LocationManager.shared.startMonitoring(
                    alarmID: alarm.id.uuidString,
                    destination: destStation,
                    radius: 3000 // 3km for wake up
                )
                print("Alarm turned ON, registered geofences.")
            }
        } else {
            // Alarm turned OFF
            LocationManager.shared.stopMonitoringRegion(purpose: .destination, alarmID: alarm.id.uuidString)
            AlarmTriggerManager.shared.endLiveActivity()
            print("Alarm turned OFF, cleared geofences.")
        }
    }
}
