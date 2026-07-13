//
//  HomePageViewModel.swift
//  Bangunin
//

import SwiftUI
import SwiftData

@Observable
class HomePageViewModel {
    
    // We pass the modelContext in to perform the delete operation.
    // The actual array of alarms is still managed via @Query in the View for reactive performance.
    func deleteAlarm(_ alarm: Alarm, context: ModelContext) {
        if alarm.isActive {
            LocationManager.shared.stopMonitoringRegion(purpose: .departure, alarmID: alarm.id.uuidString)
            LocationManager.shared.stopMonitoringRegion(purpose: .destination, alarmID: alarm.id.uuidString)
            AlarmTriggerManager.shared.endLiveActivity(for: alarm.id.uuidString)
        }
        
        context.delete(alarm)
        
        do {
            try context.save()
            print("Alarm dihapus: \(alarm.label)")
        } catch {
            print("Alarm gagal dihapus: \(error)")
        }
    }
    
    // Handles toggling the alarm off when cancelled from Live Activity or AlarmKit
    func handleAlarmCancel(alarmID: String, alarms: [Alarm], context: ModelContext) {
        if let activeAlarm = alarms.first(where: { $0.id.uuidString == alarmID }) {
            activeAlarm.isActive = false
            do {
                try context.save()
                print("Alarm berhasil dimatikan dari Live Activity/AlarmKit.")
            } catch {
                print("Gagal menyimpan update alarm ke database: \(error)")
            }
        }
    }
}
