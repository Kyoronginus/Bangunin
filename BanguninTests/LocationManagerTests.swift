//
//  LocationManagerTests.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 04/09/26.
//
import CoreLocation
import Testing
@testable import Bangunin
import SwiftData

@Suite(.serialized)
struct LocationManagerTests{
    
    // happy path
    @Test("String parsing on regionIdentifier successful")
    func test_regionIdentifierValidParsing() throws {
        
        let validString = "departure|1234-5678|Manggarai|JakartaKota"
        
        let regionId = RegionIdentifier(stringValue: validString)
        let unwrappedRegion = try #require(regionId)
        
        #expect(unwrappedRegion.purpose == .departure)
        #expect(unwrappedRegion.alarmID == "1234-5678")
        #expect(unwrappedRegion.stationName == "Manggarai")
        #expect(unwrappedRegion.targetDestination == "JakartaKota")
    }
    
    //negative path
    @Test("String parsing on regionIdentifier failed")
    func test_regionIdentifierInvalidParsing() throws {
        
        let invalidString = "departure|1234-5678"
        
        let regionId = RegionIdentifier(stringValue: invalidString)
        
        #expect(regionId == nil, "initialization must fail when the string is invalid")
    }
    
    
    // UT-009
    @Test("Prevent early lockout if fetch fails for One-Time Alarm")
    func test_handleRegionEvent_preventEarlyLockout() throws {
        // Given: We simulate entering a destination region
        let manager = CLLocationManager()
        let alarmID = UUID().uuidString
        let regionIdString = "destination|\(alarmID)|Manggarai"
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: -6.2098, longitude: 106.8502), radius: 100, identifier: regionIdString)
        
        let sut = LocationManager() 
        
        // When: The location manager determines the state is .inside
        // Because we haven't saved any alarm with `alarmID` to SwiftData, fetchAlarmIfShouldTrigger will return nil!
        sut.locationManager(manager, didDetermineState: .inside, for: region)
        
        // Then: The alarm should NOT be added to triggeredAlarmIDs (allowing it to retry later)
        // THIS WILL FAIL: Because LocationManager inserts it BEFORE checking if fetch was successful.
        #expect(sut.triggeredAlarmIDs.contains(alarmID) == false, "Alarm should not be locked out in triggeredAlarmIDs if fetching fails.")
    }
    
    // UT-010
    @Test("Toggle one-time alarm when already at destination")
    @MainActor
    func test_handleRegionEvent_oneTimeAtDestination() throws {
        // Given: We create and save an active alarm in SwiftData
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Alarm.self, configurations: config)
        let context = ModelContext(container)
        
        let alarm = Alarm(
            label: "Test", departureStation: "Bogor", destinationStation: "Manggarai",
            wakeUpTime: .oneMin, repeatOptions: [], isVibrationOn: true, isSoundOn: true, isActive: true
        )
        context.insert(alarm)
        try context.save()
        
        let sut = LocationManager() // Fresh instance!
        let mockAlarmTriggerManager = MockAlarmTriggerManager()
        sut.alarmTriggerManager = mockAlarmTriggerManager
        
        let manager = CLLocationManager()
        let regionIdString = "destination|\(alarm.id.uuidString)|Manggarai"
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: -6.2098, longitude: 106.8502), radius: 100, identifier: regionIdString)
        
        // When: We simulate the location manager returning .inside immediately
        sut.locationManager(manager, didDetermineState: .inside, for: region)
        
        // Then: fetchAlarmIfShouldTrigger should succeed, and triggerAlarm should be called.
        // THIS MIGHT FAIL INTERMITTENTLY due to the on-the-fly ModelContainer creation in `fetchAlarmIfShouldTrigger` 
        // failing to find the in-memory store we just created.
        #expect(mockAlarmTriggerManager.didCallTriggerAlarm == true, "Trigger alarm should be called successfully.")
    }
}
