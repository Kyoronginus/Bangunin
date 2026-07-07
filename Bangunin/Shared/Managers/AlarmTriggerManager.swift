//
//  AlarmTriggerManager.swift
//  Bangunin
//

import Foundation
import UserNotifications
import ActivityKit
import AlarmKit
import SwiftUI

extension Notification.Name {
    static let banguninAlarmDidCancel = Notification.Name("banguninAlarmDidCancel")
}

class AlarmTriggerManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = AlarmTriggerManager()
    
    // Store reference to the active Live Activity
    private var activeActivity: Any?
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        
        if #available(iOS 16.1, *) {
            CancelAlarmIntent.cancelAction = { alarmID in
                DispatchQueue.main.async {
                    LocationManager.shared.stopMonitoringRegion(purpose: .destination, alarmID: alarmID)
                    LocationManager.shared.isMonitoringRoute = false
                    AlarmTriggerManager.shared.endLiveActivity()
                    
                    NotificationCenter.default.post(name: .banguninAlarmDidCancel, object: nil, userInfo: ["alarmID": alarmID])
                }
            }
        }
    }
    
    func requestPermissions() {
        Task {
            do {
                let state = try await AlarmManager.shared.requestAuthorization()
                print("AlarmKit authorization state: \(state)")
            } catch {
                print("Error occurred while requesting authorization: \(error)")
            }
        }
        
        // Keep fallback UNUserNotificationCenter permission just in case
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permissions granted: \(granted)")
            }
        }
    }
    
    func triggerAlarm(for stationName: String, alarmID: String) {
        print("Triggering alarm for approaching \(stationName)!")
        
        Task {
            do {
                let alertContent = AlarmPresentation.Alert(title: "Bangun! \(stationName)")
                let countdownContent = AlarmPresentation.Countdown(title: "Bangun! \(stationName)")
                let attributes = AlarmKit.AlarmAttributes(
                    presentation: AlarmPresentation(
                        alert: alertContent,
                        countdown: countdownContent
                    ),
                    metadata: EmptyMetadata(),
                    tintColor: .cyan // Aslinya .blue
                )
                // MARK: Alarm rings 10 secs after detection
                let config = AlarmManager.AlarmConfiguration(
                    countdownDuration: AlarmKit.Alarm.CountdownDuration(preAlert: 10, postAlert: nil),
                    schedule: nil,
                    attributes: attributes,
                    stopIntent: CancelAlarmIntent(alarmID: alarmID),
                    sound: .default
                )
                
                let _ = try await AlarmManager.shared.schedule(id: UUID(), configuration: config)
                print("Alarm triggered successfully via AlarmKit.")
            } catch {
                print("Error triggering alarm with AlarmKit: \(error.localizedDescription)")
            }
        }
    }
    
    // PERBAIKAN 2: Tambahkan parameter alarmID
    func triggerDepartureNotification(for stationName: String, alarmID: String) {
        print("Triggering departure notification for \(stationName)")
        
        // Keep standard local notification for simple non-alarm banner
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
        
        startLiveActivity(destinationName: stationName, alarmID: alarmID)
    }
    
    // MARK: - Live Activity
    
    private func startLiveActivity(destinationName: String, alarmID: String) {
        if #available(iOS 16.1, *) {
            // End any existing activity first
            endLiveActivity()
            
            let attributes = BanguninAlarmAttributes(alarmID: alarmID, destinationStationName: destinationName)
            let initialContentState = BanguninAlarmAttributes.ContentState(progress: 0.5) // Example progress
            
            do {
                if #available(iOS 16.2, *) {
                    let content = ActivityContent(state: initialContentState, staleDate: nil)
                    let activity = try Activity<BanguninAlarmAttributes>.request(
                        attributes: attributes,
                        content: content,
                        pushType: nil
                    )
                    self.activeActivity = activity
                    print("Started Live Activity with ID: \(activity.id)")
                } else {
                    // Fallback for iOS 16.1
                    let activity = try Activity<BanguninAlarmAttributes>.request(
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
            if let activity = activeActivity as? Activity<BanguninAlarmAttributes> {
                Task {
                    let finalState = BanguninAlarmAttributes.ContentState(progress: 1.0)
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
