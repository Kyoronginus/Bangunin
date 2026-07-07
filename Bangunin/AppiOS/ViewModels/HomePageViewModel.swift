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
            LocationManager.shared.stopMonitoringAllRegions()
            LocationManager.shared.isMonitoringRoute = false
            AlarmTriggerManager.shared.endLiveActivity()
        }
        
        context.delete(alarm)
        
        do {
            try context.save()
            print("Alarm dihapus: \(alarm.label)")
        } catch {
            print("Alarm gagal dihapus: \(error)")
        }
    }
}
