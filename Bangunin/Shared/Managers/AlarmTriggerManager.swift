//
//  AlarmTriggerManager.swift
//  Bangunin
//

import Foundation
import UserNotifications

// To simulate AlarmKit which would be available in iOS 26+,
// we will fallback to UNUserNotificationCenter for now to trigger critical alerts.
class AlarmTriggerManager {
    static let shared = AlarmTriggerManager()
    
    private init() {}
    
    func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .criticalAlert]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permissions granted: \(granted)")
            }
        }
    }
    
    func triggerAlarm(for stationName: String) {
        print("Triggering alarm for approaching \(stationName)!")
        
        // This is where iOS 26+ AlarmKit API would be called.
        // e.g., AlarmManager.shared.scheduleImmediateAlarm(title: "Wake Up!")
        
        // Fallback: Using UNUserNotificationCenter for now.
        let content = UNMutableNotificationContent()
        content.title = "Wake Up!"
        content.body = "You are approaching \(stationName)."
        // Use a critical sound to bypass silent mode (requires entitlement in a real app, fallback to default)
        content.sound = .defaultCritical
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil) // nil trigger means fire immediately
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error triggering alarm: \(error.localizedDescription)")
            } else {
                print("Alarm triggered successfully.")
            }
        }
    }
}
