//
//  AlarmOptions.swift
//  Bangunin
//

import Foundation

enum WakeUpTime: String, CaseIterable, Codable {
    case atDestination = "Pada Stasiun Tujuan"
    case oneMin = "1 Menit Sebelum Sampai"
    case threeMin = "3 Menit Sebelum Sampai"
    case fiveMin = "5 Menit Sebelum Sampai"
    case tenMin = "10 Menit Sebelum Sampai"
    case fifteenMin = "15 Menit Sebelum Sampai"
}

extension WakeUpTime {
    var radiusInMeters: Double {
        switch self {
        case .atDestination: return 400
        case .oneMin: return 1160
        case .threeMin: return 3480
        case .fiveMin: return 5800
        case .tenMin: return 11600
        case .fifteenMin: return 17400
        }
    }
}

enum RepeatOption: String, CaseIterable, Codable {
    case monday = "Setiap Senin"
    case tuesday = "Setiap Selasa"
    case wednesday = "Setiap Rabu"
    case thursday = "Setiap Kamis"
    case friday = "Setiap Jumat"
    case saturday = "Setiap Sabtu"
    case sunday = "Setiap Minggu"
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
