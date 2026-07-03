//
//  AlarmOptions.swift
//  Bangunin
//

import Foundation

enum WakeUpTime: String, CaseIterable {
    case atDestination = "At the destination"
    case fiveMin = "5 minutes before"
    case tenMin = "10 minutes before"
    case fifteenMin = "15 minutes before"
    case twentyMin = "20 minutes before"
    case twentyFiveMin = "25 minutes before"
    case thirtyMin = "30 minutes before"
}

enum RepeatOption: String, CaseIterable {
    case sunday = "Every Sunday"
    case monday = "Every Monday"
    case tuesday = "Every Tuesday"
    case wednesday = "Every Wednesday"
    case thursday = "Every Thursday"
    case friday = "Every Friday"
    case saturday = "Every Saturday"
}
