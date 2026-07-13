//
//  ActiveAlarmCardView.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 07/07/26.
//

import SwiftUI
import CoreLocation

@Observable
class ActiveAlarmCardViewModel {
    var alarm: Alarm
    
    init(alarm: Alarm) {
        self.alarm = alarm
    }
    
    var etaString: String {
        LocationManager.shared.activeAlarmsData[alarm.id.uuidString]?.eta ?? "Menghitung..."
    }
    
    var progress: Double {
        LocationManager.shared.activeAlarmsData[alarm.id.uuidString]?.progress ?? 0.0
    }
}
