//
//  ActiveAlarmCardViewModelTests.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 10/09/26.
//

import Testing
import CoreLocation
@testable import Bangunin

struct ActiveAlarmCardViewModelTests {
    
    private func makeAlarm() -> Alarm {
        Alarm(
            label: "Test Alarm",
            departureStation: "Manggarai",
            destinationStation: "Jakarta Kota",
            wakeUpTime: .fiveMin,
            repeatOptions: [],
            isVibrationOn: true,
            isSoundOn: true
        )
    }
    
    @Test("test default state to return default value if no tracking data exists")
    func test_defaultState() {
        let alarm = makeAlarm()
        let mockLocationManager = MockLocationManager()
        
        let viewModel = ActiveAlarmCardViewModel(alarm: alarm, locationManager: mockLocationManager)
        
        #expect(viewModel.alarm.id == alarm.id)
        #expect(viewModel.etaString == "Menghitung...")
        #expect(viewModel.progress == 0.0)
        
    }
    
    @Test("Active state test to return live ETA and progress if alarm data exists")
    func test_activeState() {
        let alarm = makeAlarm()
        let mockLocationManager = MockLocationManager()
        mockLocationManager.activeAlarmsData[alarm.id.uuidString] = LocationManager.ActiveAlarmData(
            destinationCoordinate: CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.7975),
            totalDistance: 5000,
            progress: 0.5,
            eta: "10 menit"
        )
        
        let viewModel = ActiveAlarmCardViewModel(alarm: alarm, locationManager: mockLocationManager)
        
        #expect(viewModel.etaString == "10 menit")
        #expect(viewModel.progress == 0.5)
    }
    
    @Test("test ETA String")
    func test_etaString() {
        
    }
    
    
}
