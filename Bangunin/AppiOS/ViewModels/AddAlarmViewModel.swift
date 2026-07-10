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
    var destinationStation: Station = .none
    var wakeMeUpAt: WakeUpTime = .fiveMin
    var selectedRepeatOptions: Set<RepeatOption> = []
    var isVibrationOn: Bool = true
    var isSoundOn: Bool = false

    private var editingAlarm: Alarm?

    var isEditMode: Bool {
        editingAlarm != nil
    }
    
    var isFormValid: Bool {
        return departureStation.name != Station.none.name &&
            destinationStation.name != Station.none.name
    }

    init(editingAlarm: Alarm? = nil) {
        self.editingAlarm = editingAlarm

        if let alarm = editingAlarm {
            self.alarmName = alarm.label
            self.departureStation = findStation(name: alarm.departureStation) ?? .none
            self.destinationStation = findStation(name: alarm.destinationStation) ?? .none
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
    
    var allStations: [Station] { // for departure
        let all = RouteData.routeStations.values.flatMap { $0 }
        var uniqueStations = [String: Station]()
        for station in all {
            uniqueStations[station.name] = station
        }
        
        return uniqueStations.values.sorted { $0.name < $1.name }
    }
    
    func getAvailableDestinations(for departure: Station) -> [Station] {
        if departure.name == Station.none.name { return [] }
        
        let validRoutes = RouteData.routeStations.filter { $0.value.contains(where: { $0.name == departure.name }) }.keys // search for route line
        
        var validStations = [String: Station]()
        for route in validRoutes {
            if let stations = RouteData.routeStations[route] {
                for station in stations where station.name != departure.name { // departure station != destination station
                    validStations[station.name] = station
                }
            }
        }
        
        return validStations.values.sorted { $0.name < $1.name } // return sorted station
    }
    
//    func getRoute(for station: Station) -> RouteLine? {
//        if station == .none { return nil }
//
//        for (route, stations) in RouteData.routeStations {
//            // Asumsi pencocokan menggunakan nama stasiun
//            if stations.contains(where: { $0.name == station.name }) {
//                return route
//            }
//        }
//        
//        return nil
//    }
    
    func saveAlarm(context: ModelContext) {
            // Convert wakeMeUpAt to an approximate distance radius
            var distanceRadiusInMeters: Double
            switch wakeMeUpAt {
                case .atDestination: distanceRadiusInMeters = 200
                case .oneMin: distanceRadiusInMeters = 1160
                case .threeMin: distanceRadiusInMeters = 3480
                case .fiveMin: distanceRadiusInMeters = 5800
                case .tenMin: distanceRadiusInMeters = 11600
                case .fifteenMin: distanceRadiusInMeters = 17400
            }
            
            let finalLabel = alarmName.isEmpty ? "New Alarm" : alarmName
            
            let targetAlarmID: String

            if let alarm = editingAlarm {  // UPDATE
                alarm.label = finalLabel
                alarm.departureStation = departureStation.name
                alarm.destinationStation = destinationStation.name
                alarm.wakeUpTime = wakeMeUpAt
                alarm.repeatOptions = Array(selectedRepeatOptions)
                alarm.isVibrationOn = isVibrationOn
                alarm.isSoundOn = isSoundOn
                
                alarm.isActive = true
                targetAlarmID = alarm.id.uuidString // Ambil ID alarm yg diedit
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
                targetAlarmID = newAlarm.id.uuidString // Ambil ID alarm yg baru dibuat
            }
            
            // Save Context
            do {
                try context.save()
                print("Alarm berhasil disimpan: \(finalLabel)")
            } catch {
                print("Gagal menyimpan alarm: \(error)")
            }
            
            LocationManager.shared.stopMonitoringAllRegions()
            LocationManager.shared.isMonitoringRoute = false
            AlarmTriggerManager.shared.endLiveActivity()
            
            if selectedRepeatOptions.isEmpty {
                // One-Time Alarm: Immediate tracking
                let distance = LocationManager.shared.distanceTo(destinationCoordinate: destinationStation.coordinate) ?? 10000 // default fallback
                LocationManager.shared.activeTotalDistance = distance
                LocationManager.shared.activeDestinationCoordinate = destinationStation.coordinate
                LocationManager.shared.activeAlarmID = targetAlarmID
                LocationManager.shared.isMonitoringRoute = true
                
                LocationManager.shared.setupDestinationTrigger(
                    alarmID: targetAlarmID,
                    destination: destinationStation,
                    radius: wakeMeUpAt.radiusInMeters
                )
                
                AlarmTriggerManager.shared.triggerDepartureNotification(
                    for: destinationStation.name,
                    alarmID: targetAlarmID
                )
                print("One-Time Alarm: Started tracking immediately to \(destinationStation.name)")
            } else {
                // Scheduled Alarm: Wait at departure
                LocationManager.shared.startMonitoringDeparture(
                    alarmID: targetAlarmID,
                    stationName: departureStation.name,
                    destinationName: destinationStation.name,
                    radius: 100, // radius buat departure station
                    coordinate: departureStation.coordinate
                )
                
                print("Scheduled Alarm: departure geofence registered for \(departureStation.name)")
            }
        }
}
