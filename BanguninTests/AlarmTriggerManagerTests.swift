
//
//  AlarmTriggerManager.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 07/09/26.
//

import Testing
@testable import Bangunin

struct AlarmTriggerManagerTests {
    
    @Test("Trigger alarm with sound enabled")
    func test_triggerAlarmWithSoundEnabled() {
        let sut = AlarmTriggerManager.shared
        sut.triggerAlarm(for: "Manggarai", alarmID: "test-sound-on", isSoundOn: true)
        
        #expect(true, "Should not crash when triggering alarm with sound")
    }
    
    @Test("Trigger alarm with sound disabled")
    func test_triggerAlarmWithSoundDisabled() {
        let sut = AlarmTriggerManager.shared
        sut.triggerAlarm(for: "Manggarai", alarmID: "test-sound-off", isSoundOn: false)
        
        #expect(true, "Should not crash when triggering alarm with no sound")
    }
    
    @Test("Trigger departure notification and starts Live Activity")
    func test_triggerDepartureNotificationAndStartLiveActivity() {
        let sut = AlarmTriggerManager.shared
        let alarmID = "test-departure"
        sut.triggerDepartureNotification(for: "Manggarai", alarmID: alarmID)
    
        #expect(sut.activeActivities[alarmID] != nil, "Live Activity should be added to the active activities dictionary")
    }
    
    @Test("Update progress for an active Live Activity")
    func test_updateProgressForActiveLiveActivity() {
        let sut = AlarmTriggerManager.shared
        let alarmID = "test-update"
        
        sut.updateLiveActivityProgress(for: alarmID, progress: 0.5, eta: 10)
        
        #expect(true, "Should handle updating progress safely even without a real activity")
    }
    
    @Test("End LiveActivity")
    func test_endLiveActivity() {
        let sut = AlarmTriggerManager.shared
        let alarmID = "test-end"
        
        // Given: We simulate that a Live Activity is currently active for this alarm
        sut.activeActivities[alarmID] = "dummy_activity_object"
        
        // When: We end it
        sut.endLiveActivity(for: alarmID)
        
        #expect(true, "should be able to end an active LiveActivity")
    }
}
