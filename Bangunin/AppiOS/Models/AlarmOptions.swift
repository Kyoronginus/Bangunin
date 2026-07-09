//
//  AlarmOptions.swift
//  Bangunin
//

import Foundation

enum WakeUpTime: String, CaseIterable, Codable {
    case atDestination = "At the destination"
    case oneMin = "1 minute before"
    case threeMin = "3 minutes before"
    case fiveMin = "5 minutes before"
    case tenMin = "10 minutes before"
    case fifteenMin = "15 minutes before"
}

enum RepeatOption: String, CaseIterable, Codable {
    case sunday = "Every Sunday"
    case monday = "Every Monday"
    case tuesday = "Every Tuesday"
    case wednesday = "Every Wednesday"
    case thursday = "Every Thursday"
    case friday = "Every Friday"
    case saturday = "Every Saturday"
}

extension RepeatOption {
    static var currentDay: RepeatOption {
        let weekday = Calendar.current.component(.weekday, from: Date())
        switch weekday {
        case 1: return .sunday
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default: return .sunday
        }
    }
}
