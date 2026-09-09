//
//  Mocks.swift
//  BanguninTests
//

import Foundation
import CoreLocation
@testable import Bangunin

class MockLocationManager: LocationManaging {
    var activeAlarmsData: [String : LocationManager.ActiveAlarmData] = [:]
    
    var didCallSetupDestinationTrigger = false
    var didCallStartMonitoringDeparture = false
    var distanceToReturn: CLLocationDistance? = 10000
    
    func distanceTo(destinationCoordinate: CLLocationCoordinate2D) -> CLLocationDistance? {
        return distanceToReturn
    }
    
    func setupDestinationTrigger(alarmID: String, destination: Station, radius: CLLocationDistance) {
        didCallSetupDestinationTrigger = true
    }
    
    func startMonitoringDeparture(alarmID: String, stationName: String, destinationName: String, radius: CLLocationDistance, coordinate: CLLocationCoordinate2D) {
        didCallStartMonitoringDeparture = true
    }
    
    func stopMonitoringRegion(purpose: RegionPurpose, alarmID: String) {
 
    }
}

class MockAlarmTriggerManager: AlarmTriggerManaging {
    var didCallTriggerAlarm = false
    var didCallTriggerDepartureNotification = false
    var didCallEndLiveActivity = false
    
    func triggerAlarm(for stationName: String, alarmID: String, isSoundOn: Bool) {
        didCallTriggerAlarm = true
    }
    
    func triggerDepartureNotification(for stationName: String, alarmID: String) {
        didCallTriggerDepartureNotification = true
    }
    
    func updateLiveActivityProgress(for alarmID: String, progress: Double, eta: Int) {

    }
    
    func endLiveActivity(for alarmID: String) {
        didCallEndLiveActivity = true
    }
}
