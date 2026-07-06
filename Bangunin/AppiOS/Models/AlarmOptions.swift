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
