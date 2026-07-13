//
//  AlarmCardViewModel.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 05/07/26.
//

import SwiftUI
import SwiftData

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
            return "Setiap Hari"
        } else if selected == weekdays {
            return "Setiap Hari Kerja"
        } else if selected == weekends {
            return "Setiap Hari Libur"
        } else {
            return RepeatOption.allCases.filter { selected.contains($0) }
                .map { String($0.rawValue.replacingOccurrences(of: "Setiap ", with: "").prefix(3)) }
                .joined(separator: ", ")
        }
    }
    
    var isTracking: Bool {
        alarm.isActive &&
        LocationManager.shared.activeAlarmsData[alarm.id.uuidString] != nil
    }
    
    var isWaiting: Bool {
        alarm.isActive && !isTracking
    }
    
    var isOneTime: Bool {
        alarm.repeatOptions.isEmpty
    }
    
    func toggleAlarm(isActive: Bool) {
        alarm.isActive = isActive
        try? alarm.modelContext?.save()
        
        if isActive {
            if let depStation = findStation(name: alarm.departureStation),
               let destStation = findStation(name: alarm.destinationStation) {
                
                if alarm.repeatOptions.isEmpty {
                    // One-Time Alarm: Immediate tracking
                    let distance = LocationManager.shared.distanceTo(destinationCoordinate: destStation.coordinate) ?? 10000 // default fallback
                    LocationManager.shared.activeAlarmsData[alarm.id.uuidString] = LocationManager.ActiveAlarmData(
                        destinationCoordinate: destStation.coordinate,
                        totalDistance: distance
                    )
                    
                    LocationManager.shared.setupDestinationTrigger(
                        alarmID: alarm.id.uuidString,
                        destination: destStation,
                        radius: alarm.wakeUpTime.radiusInMeters
                    )
                    
                    AlarmTriggerManager.shared.triggerDepartureNotification(
                        for: destStation.name,
                        alarmID: alarm.id.uuidString
                    )
                    print("One-Time Alarm turned ON: Started tracking immediately to \(destStation.name)")
                } else {
                    // Scheduled Alarm: Wait at departure
                    LocationManager.shared.startMonitoringDeparture(
                        alarmID: alarm.id.uuidString,
                        stationName: depStation.name,
                        destinationName: destStation.name,
                        radius: 100, // Fixed radius for testing/demo
                        coordinate: depStation.coordinate
                    )
                    print("Scheduled Alarm turned ON: registered departure geofence.")
                }
            }
        } else {
            // Alarm turned OFF
            LocationManager.shared.stopMonitoringRegion(purpose: .departure, alarmID: alarm.id.uuidString)
            LocationManager.shared.stopMonitoringRegion(purpose: .destination, alarmID: alarm.id.uuidString)
            AlarmTriggerManager.shared.endLiveActivity(for: alarm.id.uuidString)
            print("Alarm turned OFF, cleared geofences.")
        }
    }
}
