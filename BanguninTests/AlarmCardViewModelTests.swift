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
    
    @Test("repeatStatus formats all repeat combinations correctly")
    func test_repeatStatus() {
        let mockLocation = MockLocationManager()
        let mockTrigger = MockAlarmTriggerManager()
        
        let alarm = Alarm(
            label: "test alarm",
            departureStation: "Sudirman",
            destinationStation: "Jakarta",
            wakeUpTime: .oneMin,
            repeatOptions: [],
            isVibrationOn: true,
            isSoundOn: true
        )
        let viewModel = AlarmCardViewModel(alarm: alarm, locationManager: mockLocation, alarmTriggerManager: mockTrigger)
        
        alarm.repeatOptions = []
        #expect(viewModel.repeatStatus == "Never")
        
        alarm.repeatOptions = RepeatOption.allCases
        #expect(viewModel.repeatStatus == "Setiap Hari")
        
        alarm.repeatOptions = [.monday, .tuesday, .wednesday, .thursday, .friday]
        #expect(viewModel.repeatStatus == "Setiap Hari Kerja")
        
        alarm.repeatOptions = [.saturday, .sunday]
        #expect(viewModel.repeatStatus == "Setiap Hari Libur")
        
        alarm.repeatOptions = [.monday, .wednesday]
        #expect(viewModel.repeatStatus == "Sen, Rab")
    }
    
    @Test("isOneTime, isTracking, and isWaiting correctly functioning")
    func test_computedProperties() {
        let mockLocation = MockLocationManager()
        let mockTrigger = MockAlarmTriggerManager()
        
        let alarm = Alarm(
            label: "test alarm",
            departureStation: "Sudirman",
            destinationStation: "Jakarta",
            wakeUpTime: .oneMin,
            repeatOptions: [],
            isVibrationOn: true,
            isSoundOn: true,
            isActive: true
        )
        
        let viewModel = AlarmCardViewModel(alarm: alarm, locationManager: mockLocation, alarmTriggerManager: mockTrigger)
        
        #expect(viewModel.isOneTime)
        #expect(viewModel.isTracking == false)
        #expect(viewModel.isWaiting)
        
        // then put into tracking mode
        mockLocation.activeAlarmsData[alarm.id.uuidString] = LocationManager.ActiveAlarmData(
            destinationCoordinate: CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.7975),
            totalDistance: 5000
        )
        
        #expect(viewModel.isOneTime)
        #expect(viewModel.isTracking)
        #expect(viewModel.isWaiting == false)
        
        
        
    }
}
