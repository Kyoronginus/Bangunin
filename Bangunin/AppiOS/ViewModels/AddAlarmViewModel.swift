//
//  AddAlarmViewModel.swift
//  Bangunin
//

import Foundation
import SwiftData
import Combine
import CoreLocation

class AddAlarmViewModel: ObservableObject {
    @Published var alarmName: String = ""
    @Published var departureStation: Station = .none
    @Published var destinationStation: Station = Station(name: "Palmerah", latitude: -6.2074, longitude: 106.7969)
    @Published var wakeMeUpAt: WakeUpTime = .fiveMin
    @Published var selectedRepeatOptions: Set<RepeatOption> = []
    @Published var isVibrationOn: Bool = true
    @Published var isSoundOn: Bool = false
    
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
        // perlu diganti jadi logic geofencing pake kecepatan kereta konstan
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
        
        let newAlarm = Alarm(
            label: alarmName.isEmpty ? "New Alarm" : alarmName,
            departureStation: departureStation.name,
            destinationStation: destinationStation.name,
            wakeUpTime: wakeMeUpAt,
            repeatOptions: Array(selectedRepeatOptions),
            isVibrationOn: isVibrationOn,
            isSoundOn: isSoundOn,
            isActive: true
        )
        context.insert(newAlarm)
        
        // Start monitoring using LocationManager singleton
        LocationManager.shared.startMonitoringDeparture(
            stationName: departureStation.name,
            destinationName: destinationStation.name,
            radius: 100, // radius buat departure station
            coordinate: departureStation.coordinate
        )
        LocationManager.shared.startMonitoring(destination: destinationStation, radius: distanceRadiusInMeters)
        
        print("Alarm saved for \(destinationStation.name) with radius \(distanceRadiusInMeters)m")
    }
}
