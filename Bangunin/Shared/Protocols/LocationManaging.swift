//
//  LocationManaging.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 07/09/26.
//

import CoreLocation

protocol LocationManaging {
    var activeAlarmsData: [String: LocationManager.ActiveAlarmData] { get set }
    func requestPermission()
    func distanceTo(destinationCoordinate: CLLocationCoordinate2D) -> CLLocationDistance?
    func setupDestinationTrigger(alarmID: String, destination: Station, radius: CLLocationDistance)
    func startMonitoringDeparture(alarmID: String, stationName: String, destinationName: String, radius: CLLocationDistance, coordinate: CLLocationCoordinate2D)
    func stopMonitoringRegion(purpose: RegionPurpose, alarmID: String)
}
