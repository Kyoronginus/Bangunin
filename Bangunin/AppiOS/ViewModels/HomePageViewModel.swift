//
//  HomePageViewModel.swift
//  Bangunin
//

import SwiftUI
import SwiftData

@Observable
class HomePageViewModel {
    var showAddAlarm: Bool = false
    var selectedAlarm: Alarm? = nil
    
//    private var locationManager = LocationManager.shared
    @ObservationIgnored private var locationManager: LocationManaging
    @ObservationIgnored private var alarmTriggerManager: AlarmTriggerManaging
    
    init(
        locationManager: LocationManaging = LocationManager.shared,
        alarmTriggerManager: AlarmTriggerManaging = AlarmTriggerManager.shared
    ) {
        self.locationManager = locationManager
        self.alarmTriggerManager = alarmTriggerManager
    }
    
    func activeAlarms(from alarms: [Alarm]) -> [Alarm] {
        let activeIDs = locationManager.activeAlarmsData.keys
        return alarms.filter { activeIDs.contains($0.id.uuidString) }
    }
    
    func inactiveAlarms(from alarms: [Alarm]) -> [Alarm] {
        let activeIDs = locationManager.activeAlarmsData.keys
        return alarms.filter { !activeIDs.contains($0.id.uuidString) }
    }
    
    func requestLocationPermission() {
        locationManager.requestPermission()
    }
    
    func requestNotificationPermission() {
        alarmTriggerManager.requestPermissions()
    }
    
    // We pass the modelContext in to perform the delete operation.
    // The actual array of alarms is still managed via @Query in the View for reactive performance.
    func deleteAlarm(_ alarm: Alarm, context: ModelContext) {
        if alarm.isActive {
            locationManager.stopMonitoringRegion(purpose: .departure, alarmID: alarm.id.uuidString)
            locationManager.stopMonitoringRegion(purpose: .destination, alarmID: alarm.id.uuidString)
            alarmTriggerManager.endLiveActivity(for: alarm.id.uuidString)
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
