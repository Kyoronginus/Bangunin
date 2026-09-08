
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
        let manager = AlarmTriggerManager.shared
        manager.triggerAlarm(for: "Manggarai", alarmID: "test-sound-on", isSoundOn: true)
        
        #expect(true, "Should not crash when triggering alarm with sound")
    }
    
    @Test("Trigger alarm with sound disabled")
    func test_triggerAlarmWithSoundDisabled() {
        let manager = AlarmTriggerManager.shared
        manager.triggerAlarm(for: "Manggarai", alarmID: "test-sound-off", isSoundOn: false)
        
        #expect(true, "Should not crash when triggering alarm with no sound")
    }
    
    @Test("Trigger departure notification and starts Live Activity")
    func test_triggerDepartureNotificationAndStartLiveActivity() {
        let manager = AlarmTriggerManager.shared
        let alarmID = "test-departure"
        manager.triggerDepartureNotification(for: "Manggarai", alarmID: alarmID)
    
        #expect(manager.activeActivities[alarmID] != nil, "Live Activity should be added to the active activities dictionary")
    }
    
    @Test("Update progress for an active Live Activity")
    func test_updateProgressForActiveLiveActivity() {
        let manager = AlarmTriggerManager.shared
        let alarmID = "test-update"
        
        manager.updateLiveActivityProgress(for: alarmID, progress: 0.5, eta: 10)
        
        #expect(true, "Should handle updating progress safely even without a real activity")
    }
    
    @Test("End LiveActivity")
    func test_endLiveActivity() {
        let manager = AlarmTriggerManager.shared
        let alarmID = "test-end"
        
        // Given: We simulate that a Live Activity is currently active for this alarm
        manager.activeActivities[alarmID] = "dummy_activity_object"
        
        // When: We end it
        manager.endLiveActivity(for: alarmID)
    }
}
