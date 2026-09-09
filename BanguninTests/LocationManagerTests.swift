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
        
        // Then: The alarm should not be added to triggeredAlarmIDs (allowing it to retry later)
        #expect(sut.triggeredAlarmIDs.contains(alarmID) == false, "Alarm should not be locked out in triggeredAlarmIDs if fetching fails.")
    }
    
    @Test("Toggle one-time alarm with 'None' as departure station")
    func test_toggleAlarm_oneTime_noDepartureStation() throws {
        
        // Given: A one-time alarm with "None" as departure
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Alarm.self, configurations: config)
        let context = ModelContext(container)
        
        let alarm = Alarm(
            label: "Test One-Time",
            departureStation: "None",
            destinationStation: "Jakarta Kota",
            wakeUpTime: .oneMin,
            repeatOptions: [],
            isVibrationOn: true,
            isSoundOn: true,
            isActive: false
        )
        
        context.insert(alarm)
        try context.save()
        
        let mockLocationManager = MockLocationManager()
        let mockAlarmTriggerManager = MockAlarmTriggerManager()
        
        let viewModel = AlarmCardViewModel(
            alarm: alarm,
            locationManager: mockLocationManager,
            alarmTriggerManager: mockAlarmTriggerManager
        )
        
        // When: We toggle the alarm on
        viewModel.toggleAlarm(isActive: true)
        
        #expect(viewModel.alarm.isActive == true)
        #expect(mockLocationManager.didCallSetupDestinationTrigger == true, "It should instantly set up the destination trigger for a one-time alarm, even if departure is 'None'.")
    }

}
