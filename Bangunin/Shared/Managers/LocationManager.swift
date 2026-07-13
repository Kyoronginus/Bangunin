//
//  LocationManager.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 03/07/26.
//

import Foundation
import CoreLocation
import SwiftData

enum RegionPurpose: String {
    case departure
    case destination
}

struct RegionIdentifier {
    let purpose: RegionPurpose
    let alarmID: String
    let stationName: String
    let targetDestination: String?

    // Memberwise initializer
    init(
        purpose: RegionPurpose,
        alarmID: String,
        stationName: String,
        targetDestination: String? = nil
    ) {
        self.purpose = purpose
        self.alarmID = alarmID
        self.stationName = stationName
        self.targetDestination = targetDestination
    }

    var stringValue: String {
        if let dest = targetDestination {
            return "\(purpose.rawValue)|\(alarmID)|\(stationName)|\(dest)"
        }
        return "\(purpose.rawValue)|\(alarmID)|\(stationName)"
    }

    // Failable initializer from string
    init?(stringValue: String) {
        let parts = stringValue.split(separator: "|")
        guard parts.count >= 3,
            let purpose = RegionPurpose(rawValue: String(parts[0]))
        else {
            return nil
        }
        self.purpose = purpose

        self.alarmID = String(parts[1])
        self.stationName = String(parts[2])
        if parts.count == 4 {
            self.targetDestination = String(parts[3])
        } else {
            self.targetDestination = nil
        }
    }
}

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {

    // Singleton instance for easy background access
    static let shared = LocationManager()

    // The underlying CoreLocation manager
    private let manager = CLLocationManager()

    // Properties that your Views can observe
    var userLocation: CLLocation?
    var authorizationStatus: CLAuthorizationStatus

    var lastUpdateTimestamp: Date?
    var lastError: String?
    
    // Untuk tracking Live Activity di background
    var isMonitoringRoute: Bool {
        !activeAlarmsData.isEmpty
    }
    
    struct ActiveAlarmData {
        var destinationCoordinate: CLLocationCoordinate2D
        var totalDistance: Double
        var progress: Double = 0.0
        var eta: String = "Menghitung..."
    }
    
    var activeAlarmsData: [String: ActiveAlarmData] = [:]
    
    private var triggeredAlarmIDs: Set<String> = []


    private override init() {
        // Initialize the starting authorization status
        self.authorizationStatus = manager.authorizationStatus
        super.init()

        // Set the delegate so we can receive location updates
        manager.delegate = self

        // Optimize battery by setting the appropriate accuracy
        manager.desiredAccuracy = kCLLocationAccuracyBest

        // Safety check to prevent NSInternalInconsistencyException if capability is missing
        if let modes = Bundle.main.object(
            forInfoDictionaryKey: "UIBackgroundModes"
        ) as? [String], modes.contains("location") {
            manager.allowsBackgroundLocationUpdates = true
        } else {
            print(
                "WARNING: Missing 'location' in UIBackgroundModes capability. Background updates disabled to prevent crash."
            )
        }

        manager.pausesLocationUpdatesAutomatically = false
    }

    // MARK: - Intents

    func requestPermission() {
        // First, request when-in-use. We will automatically request Always in the delegate callback once this is granted.
        manager.requestWhenInUseAuthorization()
    }

    func startTracking() {
        manager.startUpdatingLocation()
    }

    func stopTracking() {
        manager.stopUpdatingLocation()
    }

    func setupDestinationTrigger(
        alarmID: String,
        destination: Station,
        radius: CLLocationDistance
    ) {
        guard
            CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self)
        else { return }
        let identifier = RegionIdentifier(
            purpose: .destination,
            alarmID: alarmID,
            stationName: destination.name
        ).stringValue
        let region = CLCircularRegion(
            center: destination.coordinate,
            radius: radius,
            identifier: identifier
        )
        region.notifyOnEntry = true
        region.notifyOnExit = false
        manager.startMonitoring(for: region)
        manager.requestState(for: region)
    }

    func stopMonitoringAllRegions() {
        for region in manager.monitoredRegions {
            manager.stopMonitoring(for: region)
        }
        activeAlarmsData.removeAll()
    }

    func stopMonitoringRegion(purpose: RegionPurpose, alarmID: String) {
        triggeredAlarmIDs.remove(alarmID)
        
        activeAlarmsData.removeValue(forKey: alarmID)
        
        for region in manager.monitoredRegions {
            if let regionId = RegionIdentifier(stringValue: region.identifier),
                regionId.purpose == purpose && regionId.alarmID == alarmID
            {
                manager.stopMonitoring(for: region)
                print(
                    "Berhasil menghapus geofence spesifik: \(region.identifier)"
                )
            }
        }
    }

    // MARK: - Testing / Departure

    func startMonitoringDeparture(
        alarmID: String,
        stationName: String,
        destinationName: String,
        radius: CLLocationDistance,
        coordinate: CLLocationCoordinate2D
    ) {
        guard
            CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self)
        else {
            print("Geofencing is not supported on this device!")
            return
        }

        let identifier = RegionIdentifier(
            purpose: .departure,
            alarmID: alarmID,
            stationName: stationName,
            targetDestination: destinationName
        ).stringValue
        let region = CLCircularRegion(
            center: coordinate,
            radius: radius,
            identifier: identifier
        )
        region.notifyOnEntry = true
        region.notifyOnExit = false

        manager.startMonitoring(for: region)
        // Request the state immediately to see if we are already inside
        manager.requestState(for: region)
        print(
            "Started monitoring DEPARTURE region around \(stationName) with radius \(radius) meters."
        )
    }

    // MARK: - CLLocationManagerDelegate

    // This is called automatically whenever the user's location changes
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let latestLocation = locations.last else { return }
        self.userLocation = latestLocation
        self.lastUpdateTimestamp = Date()
        self.lastError = nil // clear error on successful update
        
        // Push update ke Live Activity di background jika sedang monitoring
        for (alarmID, data) in activeAlarmsData {
            let destLoc = CLLocation(latitude: data.destinationCoordinate.latitude, longitude: data.destinationCoordinate.longitude)
            let remainingDist = latestLocation.distance(from: destLoc)
            
            let traveledDist = data.totalDistance - remainingDist
            let progress = min(max(traveledDist / data.totalDistance, 0.0), 1.0)
            
            // 1. Calculate ETA using your existing formula
            let eta = calculateEstimateTime(distanceInMeters: remainingDist)
            
            self.activeAlarmsData[alarmID]?.progress = progress
            self.activeAlarmsData[alarmID]?.eta = "\(eta) menit"
            
            // 2. Passing to the manager
            AlarmTriggerManager.shared.updateLiveActivityProgress(for: alarmID, progress: progress, eta: eta)
        }
    }

    // This is called automatically whenever the user changes the location permission
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus

        // If the user granted WhenInUse, IMMEDIATELY ask for Always authorization
        // to force the "Upgrade to Always" prompt to appear right now instead of later.
        if authorizationStatus == .authorizedWhenInUse {
            manager.requestAlwaysAuthorization()
        }

        // If the user granted permission, start tracking immediately
        if authorizationStatus == .authorizedWhenInUse
            || authorizationStatus == .authorizedAlways
        {
            startTracking()
        }
    }

    // Triggered when the user enters the geofence radius
    func locationManager(
        _ manager: CLLocationManager,
        didEnterRegion region: CLRegion
    ) {
        print("Did Enter Region: \(region.identifier)")

        // Logika untuk stasiun:
        handleRegionEvent(region: region, state: .inside)
    }

    // Triggered when we request the state (e.g. immediately after registering)
    func locationManager(
        _ manager: CLLocationManager,
        didDetermineState state: CLRegionState,
        for region: CLRegion
    ) {
        print(
            "Did Determine State for \(region.identifier): \(state == .inside ? "Inside" : "Outside/Unknown")"
        )

        if state == .inside {
            handleRegionEvent(region: region, state: .inside)
        }
    }

    private func handleRegionEvent(region: CLRegion, state: CLRegionState) {
        // Prevent double triggering if already monitoring route
        guard state == .inside else { return }

        // Decode the structured identifier
        guard let regionId = RegionIdentifier(stringValue: region.identifier)
        else {
            print("Unknown region format: \(region.identifier)")
            return
        }

        switch regionId.purpose {
        case .departure:
            if self.activeAlarmsData[regionId.alarmID] == nil {
                guard let alarm = fetchAlarmIfShouldTrigger(alarmID: regionId.alarmID) else {
                    return
                }

                print(
                    "User is at departure station. Start alarm monitoring state."
                )

                let destName = regionId.targetDestination ?? "Destination"
                
                // Track coordinates for Live Activity Background Update
                if let departureStation = findStation(name: regionId.stationName),
                   let destinationStation = findStation(name: destName) {
                    
                    let depLoc = CLLocation(latitude: departureStation.coordinate.latitude, longitude: departureStation.coordinate.longitude)
                    let destLoc = CLLocation(latitude: destinationStation.coordinate.latitude, longitude: destinationStation.coordinate.longitude)
                    
                    self.activeAlarmsData[regionId.alarmID] = ActiveAlarmData(
                        destinationCoordinate: destinationStation.coordinate,
                        totalDistance: depLoc.distance(from: destLoc)
                    )
                    
                    // NEW: Start monitoring the destination station here!
                    self.setupDestinationTrigger(
                        alarmID: regionId.alarmID,
                        destination: destinationStation,
                        radius: alarm.wakeUpTime.radiusInMeters
                    )
                }
                
                AlarmTriggerManager.shared.triggerDepartureNotification(
                    for: destName,
                    alarmID: regionId.alarmID
                )
            }

        case .destination:
            if !triggeredAlarmIDs.contains(regionId.alarmID) {
                print("User near destination station! Trigger alarm!")

                triggeredAlarmIDs.insert(regionId.alarmID)
                
                guard let alarm = fetchAlarmIfShouldTrigger(alarmID: regionId.alarmID) else {
                    print("alarm silent gagal di trigger")
                    return
                }


                AlarmTriggerManager.shared.triggerAlarm(
                    for: regionId.stationName,
                    alarmID: regionId.alarmID,
                    isSoundOn: alarm.isSoundOn
                )
            } else {
                print(
                    "Alarm \(regionId.alarmID) triggered!"
                )
            }
        }
    }

    // Handle errors (important for debugging)
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print(
            "LocationManager failed with error: \(error.localizedDescription)"
        )
        self.lastError = error.localizedDescription
    }
    
    // Menghitung jarak dari lokasi user saat ini ke sebuah titik koordinat (contoh: stasiun tujuan)
    func distanceTo(destinationCoordinate: CLLocationCoordinate2D) -> CLLocationDistance? {
        guard let current = userLocation else { return nil }
        let destination = CLLocation(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude)
        return current.distance(from: destination)
    }
    
    private func fetchAlarmIfShouldTrigger(alarmID: String) -> Alarm? {
        guard let container = try? ModelContainer(for: Alarm.self) else { return nil }
        let context = ModelContext(container)
        let descriptor = FetchDescriptor<Alarm>()
        guard let alarms = try? context.fetch(descriptor) else { return nil }
        
        guard let alarm = alarms.first(where: { $0.id.uuidString == alarmID }) else { return nil }
        
        if !alarm.isActive {
            print("Alarm is toggled off! Ignored.")
            return nil
        }
        
        if alarm.repeatOptions.isEmpty {
            return alarm
        }
        
        let isTodayIncluded = alarm.repeatOptions.contains(RepeatOption.currentDay)
        if !isTodayIncluded {
            print("Alarm is not scheduled for today (\\(RepeatOption.currentDay.rawValue)). Ignored.")
            return nil
        }
        return alarm
    }
}
