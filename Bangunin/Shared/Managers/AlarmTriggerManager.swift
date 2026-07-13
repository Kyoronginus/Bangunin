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
    
    // Store reference to the active Live Activities keyed by alarmID
    private var activeActivities: [String: Any] = [:]
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        
        if #available(iOS 16.1, *) {
            CancelAlarmIntent.cancelAction = { alarmID in
                DispatchQueue.main.async {
                    LocationManager.shared.stopMonitoringRegion(purpose: .departure, alarmID: alarmID)
                    LocationManager.shared.stopMonitoringRegion(purpose: .destination, alarmID: alarmID)
                    AlarmTriggerManager.shared.endLiveActivity(for: alarmID)
                    
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
    
    func triggerAlarm(for stationName: String, alarmID: String, isSoundOn: Bool) {
        print("isSoundOn value: \(isSoundOn)")
        print("Triggering alarm for approaching \(stationName)!")
        
        // MARK: Alarm Fullscreen View
        Task {
            do {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                let currentTime = formatter.string(from: Date())
                
                let alertContent = AlarmPresentation.Alert(title: "\(currentTime)")
                let attributes = AlarmKit.AlarmAttributes(
                    presentation: AlarmPresentation(
                        alert: alertContent,
                        countdown: nil
                    ),
                    metadata: EmptyMetadata(),
                    tintColor: .orange
                )
                // MARK: Alarm rings 10 secs after detection
                let config = AlarmManager.AlarmConfiguration(
                    countdownDuration: AlarmKit.Alarm.CountdownDuration(preAlert: 10, postAlert: nil),
                    schedule: nil,
                    attributes: attributes,
                    stopIntent: CancelAlarmIntent(alarmID: alarmID),
                    secondaryIntent: CancelAlarmIntent(alarmID: alarmID),
                    sound: isSoundOn ? .default : .named("silent.wav")
                )
                
                
                let _ = try await AlarmManager.shared.schedule(id: UUID(), configuration: config)
                print("Alarm triggered successfully via AlarmKit.")
            } catch {
                print("Error triggering alarm with AlarmKit: \(error.localizedDescription)")
            }
        }
    }
    
    func triggerDepartureNotification(for stationName: String, alarmID: String) {
        print("Triggering departure notification for \(stationName)")
        
        // Keep standard local notification for simple non-alarm banner
        let content = UNMutableNotificationContent()
        content.title = "Alarm Aktif"
        content.body = "Kamu akan dibangunin sebelum sampai \(stationName)"
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
        // End any existing activity for this alarm first
        endLiveActivity(for: alarmID)
        
        let attributes = BanguninAlarmAttributes(alarmID: alarmID, destinationStationName: destinationName)
        let initialContentState = BanguninAlarmAttributes.ContentState(progress: 0.0) // Start at 0
        let content = ActivityContent(state: initialContentState, staleDate: nil)
        
        do {
            let activity = try Activity<BanguninAlarmAttributes>.request(
                attributes: attributes,
                content: content,
                pushType: nil
            )
            self.activeActivities[alarmID] = activity
            print("Started Live Activity with ID: \(activity.id) for alarm: \(alarmID)")
        } catch {
            print("Error starting Live Activity: \(error.localizedDescription)")
        }
    }
    
    func updateLiveActivityProgress(for alarmID: String, progress: Double, eta: Int) {
        guard let activity = activeActivities[alarmID] as? Activity<BanguninAlarmAttributes> else { return }
        
        Task {
            let updatedState = BanguninAlarmAttributes.ContentState(progress: progress, estimatedMinutesRemaining: eta)
            let content = ActivityContent(state: updatedState, staleDate: nil)
            await activity.update(content)
        }
    }
    
    func endLiveActivity(for alarmID: String) {
        guard let activity = activeActivities[alarmID] as? Activity<BanguninAlarmAttributes> else { return }
        
        Task {
            let finalState = BanguninAlarmAttributes.ContentState(progress: 1.0)
            let finalContent = ActivityContent(state: finalState, staleDate: nil)
            await activity.end(finalContent, dismissalPolicy: .immediate)
            print("Ended Live Activity for alarm: \(alarmID)")
        }
        self.activeActivities.removeValue(forKey: alarmID)
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
