//
//  AlarmsData.swift
//  Bangunin
//
//  Created by Kezia Karen Amelia on 02/07/26.
//

// struktur data alarms -> SwiftData(?)

import Foundation
import SwiftData

@Model
final class Alarm {
    var label: String
    var departureStation: String
    var destinationStation: String
    var wakeUpTime: WakeUpTime
    var repeatOptions: [RepeatOption]
    var isVibrationOn: Bool
    var isSoundOn: Bool
    var isActive: Bool
    var createdAt: Date

    init(
        label: String,
        departureStation: String,
        destinationStation: String,
        wakeUpTime: WakeUpTime,
        repeatOptions: [RepeatOption],
        isVibrationOn: Bool,
        isSoundOn: Bool,
        isActive: Bool = true,
        createdAt: Date = .now
    ) {
        self.label = label
        self.departureStation = departureStation
        self.destinationStation = destinationStation
        self.wakeUpTime = wakeUpTime
        self.repeatOptions = repeatOptions
        self.isVibrationOn = isVibrationOn
        self.isSoundOn = isSoundOn
        self.isActive = isActive
        self.createdAt = createdAt
    }

}
