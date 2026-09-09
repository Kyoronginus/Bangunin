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
    @ObservationIgnored var locationManager: LocationManaging
    @ObservationIgnored var alarmTriggerManager: AlarmTriggerManaging
    
    init(alarm: Alarm,
         locationManager: LocationManaging = LocationManager.shared,
         alarmTriggerManager: AlarmTriggerManaging = AlarmTriggerManager.shared) {
        self.alarm = alarm
        self.locationManager = locationManager
        self.alarmTriggerManager = alarmTriggerManager
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
        locationManager.activeAlarmsData[alarm.id.uuidString] != nil
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
            // We ONLY strictly require the destination station
            if let destStation = findStation(name: alarm.destinationStation) {
                
                // Departure station is optional (One-time alarms save it as "None")
                let depStation = findStation(name: alarm.departureStation)
                let distanceToDeparture = depStation.map { locationManager.distanceTo(destinationCoordinate: $0.coordinate) ?? 10000 } ?? 10000
                
                if alarm.repeatOptions.isEmpty || distanceToDeparture <= 300 {
                    // One-Time Alarm: Immediate tracking
                    let distance = locationManager.distanceTo(destinationCoordinate: destStation.coordinate) ?? 10000 // default fallback
                    locationManager.activeAlarmsData[alarm.id.uuidString] = LocationManager.ActiveAlarmData(
                        destinationCoordinate: destStation.coordinate,
                        totalDistance: distance
                    )
                    
                    locationManager.setupDestinationTrigger(
                        alarmID: alarm.id.uuidString,
                        destination: destStation,
                        radius: alarm.wakeUpTime.radiusInMeters
                    )
                    
                    alarmTriggerManager.triggerDepartureNotification(
                        for: destStation.name,
                        alarmID: alarm.id.uuidString
                    )
                    print("One-Time Alarm turned ON: Started tracking immediately to \(destStation.name)")
                    
                } else if let depStation = depStation {
                    // Scheduled Alarm: Wait at departure
                    locationManager.startMonitoringDeparture(
                        alarmID: alarm.id.uuidString,
                        stationName: depStation.name,
                        destinationName: destStation.name,
                        radius: 100, // Fixed radius for testing/demo
                        coordinate: depStation.coordinate
                    )
                    print("Scheduled Alarm turned ON: registered departure geofence.")
                } else {
                    print("ERROR: Scheduled alarm turned ON but missing a valid departure station!")
                }
            } else {
                print("ERROR: Failed to find destination station: '\(alarm.destinationStation)'")
            }
        } else {
            // Alarm turned OFF
            locationManager.stopMonitoringRegion(purpose: .departure, alarmID: alarm.id.uuidString)
            locationManager.stopMonitoringRegion(purpose: .destination, alarmID: alarm.id.uuidString)
            alarmTriggerManager.endLiveActivity(for: alarm.id.uuidString)
            print("Alarm turned OFF, cleared geofences.")
        }
    }

}
