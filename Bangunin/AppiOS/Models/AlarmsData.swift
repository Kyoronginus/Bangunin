//
//  AlarmsData.swift
//  Bangunin
//
//  Created by Kezia Karen Amelia on 02/07/26.
//

// struktur data alarms -> SwiftData(?)
import Foundation

struct Alarm: Identifiable {
    let id: UUID = UUID()
    
    var label: String
    var departureStation: String
    var destinationStation: String
    var repeatStatus: String
    var isActive: Bool
}
