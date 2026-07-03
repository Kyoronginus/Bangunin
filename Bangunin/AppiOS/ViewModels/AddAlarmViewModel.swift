//
//  AddAlarmViewModel.swift
//  Bangunin
//

import Combine
import Foundation
import SwiftData

class AddAlarmViewModel: ObservableObject {
    @Published var alarmName: String = ""
    @Published var departureStation: String = "None"
    @Published var destinationStation: String = "Palmerah"
    @Published var wakeMeUpAt: WakeUpTime = .fiveMin
    @Published var selectedRepeatOptions: Set<RepeatOption> = []
    @Published var isVibrationOn: Bool = true
    @Published var isSoundOn: Bool = false

    var repeatText: String {
        let weekdays: Set<RepeatOption> = [
            .monday, .tuesday, .wednesday, .thursday, .friday,
        ]
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
            return RepeatOption.allCases.filter {
                selectedRepeatOptions.contains($0)
            }
            .map {
                String(
                    $0.rawValue.replacingOccurrences(of: "Every ", with: "")
                        .prefix(3)
                )
            }
            .joined(separator: ", ")
        }
    }

    // CREATE
    func saveAlarm(context: ModelContext) {
        let newAlarm = Alarm(
            label: alarmName,
            departureStation: departureStation,
            destinationStation: destinationStation,
            wakeUpTime: wakeMeUpAt,
            repeatOptions: Array(selectedRepeatOptions),
            isVibrationOn: isVibrationOn,
            isSoundOn: isSoundOn
        )
        context.insert(newAlarm)

        do {
            try context.save()
            print("Alarm berhasil disimpan: (newAlarm.label)")
        } catch {
            print("Gagal: (error)")
        }
    }
}
