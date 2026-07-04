//
//  AlarmTriggerManager.swift
//  Bangunin
//

import Foundation
import UserNotifications
import ActivityKit

// To simulate AlarmKit which would be available in iOS 26+,
// we will fallback to UNUserNotificationCenter for now to trigger critical alerts.
class AlarmTriggerManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = AlarmTriggerManager()
    
    // Store reference to the active Live Activity
    private var activeActivity: Any? // Using Any to avoid importing ActivityKit everywhere if not needed, but since it's shared, we can import ActivityKit
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        
        if #available(iOS 16.1, *) {
            CancelAlarmIntent.cancelAction = {
                DispatchQueue.main.async {
                    LocationManager.shared.stopMonitoringAllRegions()
                    LocationManager.shared.isMonitoringRoute = false
                    AlarmTriggerManager.shared.endLiveActivity()
                }
            }
        }
    }
    
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
    
    func triggerDepartureNotification(for stationName: String) {
        print("Triggering departure notification for \(stationName)")
        
        // Fallback: Using UNUserNotificationCenter for now.
        let content = UNMutableNotificationContent()
        content.title = "Alarm Active"
        content.body = "Monitoring route to \(stationName)."
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error triggering departure notification: \(error.localizedDescription)")
            } else {
                print("Departure notification triggered successfully.")
            }
        }
        
        // Start Live Activity
        startLiveActivity(destinationName: stationName)
    }
    
    // MARK: - Live Activity
    
    private func startLiveActivity(destinationName: String) {
        if #available(iOS 16.1, *) {
            // End any existing activity first
            endLiveActivity()
            
            let attributes = AlarmAttributes(destinationStationName: destinationName)
            let initialContentState = AlarmAttributes.ContentState(progress: 0.5) // Example progress
            
            do {
                if #available(iOS 16.2, *) {
                    let content = ActivityContent(state: initialContentState, staleDate: nil)
                    let activity = try Activity<AlarmAttributes>.request(
                        attributes: attributes,
                        content: content,
                        pushType: nil
                    )
                    self.activeActivity = activity
                    print("Started Live Activity with ID: \(activity.id)")
                } else {
                    // Fallback for iOS 16.1
                    let activity = try Activity<AlarmAttributes>.request(
                        attributes: attributes,
                        contentState: initialContentState,
                        pushType: nil
                    )
                    self.activeActivity = activity
                    print("Started Live Activity with ID: \(activity.id)")
                }
            } catch {
                print("Error starting Live Activity: \(error.localizedDescription)")
            }
        }
    }
    
    func endLiveActivity() {
        if #available(iOS 16.1, *) {
            if let activity = activeActivity as? Activity<AlarmAttributes> {
                Task {
                    let finalState = AlarmAttributes.ContentState(progress: 1.0)
                    if #available(iOS 16.2, *) {
                        let finalContent = ActivityContent(state: finalState, staleDate: nil)
                        await activity.end(finalContent, dismissalPolicy: .immediate)
                    } else {
                        await activity.end(using: finalState, dismissalPolicy: .immediate)
                    }
                    print("Ended Live Activity.")
                }
                self.activeActivity = nil
            }
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    // This ensures the notification banner shows up even if the app is currently open (foreground)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show banner and play sound
        completionHandler([.banner, .sound])
    }
}
