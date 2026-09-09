//
//  AlarmCardViewModelTests.swift
//  BanguninTests
//

import Testing
import SwiftData
import CoreLocation
@testable import Bangunin

@MainActor
struct AlarmCardViewModelTests {
    
    // UT-008
    @Test("Toggle scheduled alarm when already at destination")
    func test_toggleAlarm_scheduled_atDestination() throws {
        
        // Given: A scheduled alarm
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Alarm.self, configurations: config)
        let context = ModelContext(container)
        
        let alarm = Alarm(
            label: "Test",
            departureStation: "Manggarai",
            destinationStation: "Jakarta Kota",
            wakeUpTime: .oneMin,
            repeatOptions: [.monday, .tuesday, .wednesday, .thursday, .friday],
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
        
        // pretend the user is currently at the destination.
        mockLocationManager.distanceToReturn = 50
        
        
        
        // When: We toggle the alarm on
        viewModel.toggleAlarm(isActive: true)
        
        // Then: The alarm should become active
        #expect(viewModel.alarm.isActive == true)
        #expect(mockLocationManager.didCallSetupDestinationTrigger == true, "It should register the destination geofence directly if we are already there, but instead it blindly waits for departure.")
    }
}
