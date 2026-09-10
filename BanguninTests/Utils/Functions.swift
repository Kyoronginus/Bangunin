//
//  functions.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 10/09/26.
//
import SwiftData
import Testing
@testable import Bangunin

func makeAlarm(label: String, isActive: Bool = true) -> Alarm {
    Alarm(
        label: label,
        departureStation: "Sudirman",
        destinationStation: "Palmerah",
        wakeUpTime: .fiveMin,
        repeatOptions: [],
        isVibrationOn: true,
        isSoundOn: true,
        isActive: isActive
    )
}

func makeContext() throws -> ModelContext {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try ModelContainer(for: Alarm.self, configurations: config)
    let context = ModelContext(container)
    
    return context
}
