//
//  AlarmTriggerManaging.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 07/09/26.
//

protocol AlarmTriggerManaging {
    func requestPermissions()
    func triggerAlarm(for stationName: String, alarmID: String, isSoundOn: Bool)
    func triggerDepartureNotification(for stationName: String, alarmID: String)
    func updateLiveActivityProgress(for alarmID: String, progress: Double, eta: Int)
    func endLiveActivity(for alarmID: String)
}
