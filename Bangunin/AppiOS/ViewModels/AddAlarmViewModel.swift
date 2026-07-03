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
        // Assuming average train speed 60 km/h -> 1 km per minute
        var distanceRadiusInMeters: Double = 0
        switch wakeMeUpAt {
        case .atDestination: distanceRadiusInMeters = 500 // 500 meters (approx at station)
        case .fiveMin: distanceRadiusInMeters = 5000 // 5 km
        case .tenMin: distanceRadiusInMeters = 10000 // 10 km
        case .fifteenMin: distanceRadiusInMeters = 15000 // 15 km
        case .twentyMin: distanceRadiusInMeters = 20000 // 20 km
        case .twentyFiveMin: distanceRadiusInMeters = 25000 // 25 km
        case .thirtyMin: distanceRadiusInMeters = 30000 // 30 km
        }
        
        // Start monitoring using LocationManager singleton
        LocationManager.shared.startMonitoring(destination: destinationStation, radius: distanceRadiusInMeters)
        
        // Create Alarm for SwiftData / CoreData if needed
        // let newAlarm = Alarm(...)
        // context.insert(newAlarm)
        
        print("Alarm saved for \(destinationStation.name) with radius \(distanceRadiusInMeters)m")
    }
}
