//
//  AddAlarmViewModel.swift
//  Bangunin
//

import Foundation
import SwiftData
import Combine
import CoreLocation

@Observable
class AddAlarmViewModel {
    var alarmName: String = ""
    var departureStation: Station = .none
    var destinationStation: Station = Station(name: "Palmerah", latitude: -6.2074, longitude: 106.7969)
    var wakeMeUpAt: WakeUpTime = .fiveMin
    var selectedRepeatOptions: Set<RepeatOption> = []
    var isVibrationOn: Bool = true
    var isSoundOn: Bool = false

    private var editingAlarm: Alarm?

    var isEditMode: Bool {
        editingAlarm != nil
    }

    init(editingAlarm: Alarm? = nil) {
        self.editingAlarm = editingAlarm

        if let alarm = editingAlarm {
            self.alarmName = alarm.label
            self.departureStation = findStation(name: alarm.departureStation) ?? .none
            self.destinationStation = findStation(name: alarm.destinationStation) ?? Station(name: "Palmerah", latitude: -6.2074, longitude: 106.7969)
            self.wakeMeUpAt = alarm.wakeUpTime
            self.selectedRepeatOptions = Set(alarm.repeatOptions)
            self.isVibrationOn = alarm.isVibrationOn
            self.isSoundOn = alarm.isSoundOn
        }
    }
    
    var repeatText: String {
        let weekdays: Set<RepeatOption> = [.monday, .tuesday, .wednesday, .thursday, .friday]
        let weekends: Set<RepeatOption> = [.saturday, .sunday]
        
        if selectedRepeatOptions.isEmpty {
            return "Never"
        } else if selectedRepeatOptions.count == RepeatOption.allCases.count {
            return "Everyday"
        } else if selectedRepeatOptions == weekdays {
            return "Every Weekday"
        } else if selectedRepeatOptions == weekends {
            return "Every Weekend"
        } else {
            return RepeatOption.allCases.filter { selectedRepeatOptions.contains($0) }
                .map { String($0.rawValue.replacingOccurrences(of: "Every ", with: "").prefix(3)) }
                .joined(separator: ", ")
        }
    }
    
    func saveAlarm(context: ModelContext) {
        // Convert wakeMeUpAt to an approximate distance radius
        var distanceRadiusInMeters: Double = 0
        switch wakeMeUpAt {
            case .atDestination: distanceRadiusInMeters = 500
            case .fiveMin: distanceRadiusInMeters = 5000
            case .tenMin: distanceRadiusInMeters = 10000
            case .fifteenMin: distanceRadiusInMeters = 15000
            case .twentyMin: distanceRadiusInMeters = 20000
            case .twentyFiveMin: distanceRadiusInMeters = 25000
            case .thirtyMin: distanceRadiusInMeters = 30000
        }
        
        let finalLabel = alarmName.isEmpty ? "New Alarm" : alarmName

        if let alarm = editingAlarm {  // UPDATE
            alarm.label = finalLabel
            alarm.departureStation = departureStation.name
            alarm.destinationStation = destinationStation.name
            alarm.wakeUpTime = wakeMeUpAt
            alarm.repeatOptions = Array(selectedRepeatOptions)
            alarm.isVibrationOn = isVibrationOn
            alarm.isSoundOn = isSoundOn
        } else {
            let newAlarm = Alarm(  // CREATE
                label: finalLabel,
                departureStation: departureStation.name,
                destinationStation: destinationStation.name,
                wakeUpTime: wakeMeUpAt,
                repeatOptions: Array(selectedRepeatOptions),
                isVibrationOn: isVibrationOn,
                isSoundOn: isSoundOn,
                isActive: true
            )
            context.insert(newAlarm)
        }
        
        // Save Context
        do {
            try context.save()
            print("Alarm berhasil disimpan: \(finalLabel)")
        } catch {
            print("Gagal menyimpan alarm: \(error)")
        }
        
        // Start monitoring using LocationManager singleton
        LocationManager.shared.startMonitoringDeparture(
            stationName: departureStation.name,
            destinationName: destinationStation.name,
            radius: 100, // radius buat departure station
            coordinate: departureStation.coordinate
        )
        LocationManager.shared.startMonitoring(destination: destinationStation, radius: distanceRadiusInMeters)
        
        print("Alarm geofences registered for \(destinationStation.name) with radius \(distanceRadiusInMeters)m")
    }
}
