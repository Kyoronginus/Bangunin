//
//  HomePageViewModelTests.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 10/09/26.
//

import Testing
import SwiftData
import CoreLocation
@testable import Bangunin

struct HomePageViewModelTests {
    
    private func makeAlarm(label: String, isActive: Bool = true) -> Alarm {
        Alarm(
            label: label,
            departureStation: "Sudirman",
            destinationStation: "Palmerah",
            wakeUpTime: .fiveMin,
            repeatOptions: [],
            isVibrationOn: true,
            isSoundOn: true,
            isActive: isActive
        )
    }
    
    private func makeContext() throws -> ModelContext {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Alarm.self, configurations: config)
        let context = ModelContext(container)
        
        return context
    }
    
    @Test("Filtering active vs inactive alarms on HomePageViewModel")
    func test_activeAndInactiveAlarmsFiltering() {
        let mockLocation = MockLocationManager()
        let viewModel = HomePageViewModel(locationManager: mockLocation)
        
        let activeAlarm = makeAlarm(label: "Active")
        let inactiveAlarm = makeAlarm(label: "Inactive")
        
        mockLocation.activeAlarmsData[activeAlarm.id.uuidString] = LocationManager.ActiveAlarmData(
            destinationCoordinate: CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.7975),
            totalDistance: 5000
        )
        
        let active = viewModel.activeAlarms(from: [activeAlarm, inactiveAlarm])
        let inactive = viewModel.inactiveAlarms(from: [activeAlarm, inactiveAlarm])
        
        #expect(active.map(\.id) == [activeAlarm.id])
        #expect(inactive.map(\.id) == [inactiveAlarm.id])
    }
    
    @Test("delete alarm for active alarm triggers region cleanup and ends live activity")
    func test_deleteActiveAlarm() throws {
        let context = try makeContext()
        let mockLocation = MockLocationManager()
        let mockTrigger = MockAlarmTriggerManager()
        let viewModel = HomePageViewModel(locationManager: mockLocation, alarmTriggerManager: mockTrigger)
        
        let alarm = makeAlarm(label: "ActiveAlarm", isActive: true)
        context.insert(alarm)
        try context.save()
        
        viewModel.deleteAlarm(alarm, context: context)
        
        #expect(mockLocation.didCallStopMonitoringRegion == true)
        #expect(mockTrigger.didCallEndLiveActivity == true)
    }
    
    @Test("delete alarm for inactive alarm doesn't trigger region cleanup and ends live activity")
    func test_deleteInactiveAlarm() throws {
        let context = try makeContext()
        let mockLocation = MockLocationManager()
        let mockTrigger = MockAlarmTriggerManager()
        let viewModel = HomePageViewModel(locationManager: mockLocation, alarmTriggerManager: mockTrigger)
        
        let alarm = makeAlarm(label: "InactiveAlarm", isActive: false)
        context.insert(alarm)
        try context.save()
        
        viewModel.deleteAlarm(alarm, context: context)
        
        #expect(mockLocation.didCallStopMonitoringRegion == false)
        #expect(mockLocation.didCallSetupDestinationTrigger == false)
    }
    
    
    
    // handleAlarmCancel
    
    @Test("handleAlarmCancel sets active alarm toggled off via live activity")
    func test_handleAlarmCancel_setsActiveAlarmToggledOff() throws {
        let context = try makeContext()
        let viewModel = HomePageViewModel()
        let alarm = makeAlarm(label: "test alarm", isActive: true)
        context.insert(alarm)
        try context.save()
        
        viewModel.handleAlarmCancel(alarmID: alarm.id.uuidString, alarms: [alarm], context: context)
        
        #expect(alarm.isActive == false)
        let fetched = try context.fetch(FetchDescriptor<Alarm>())
        #expect(fetched.first?.isActive == false)
    }
}
