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
    @ObservationIgnored var locationManager: LocationManaging
    
    init(alarm: Alarm, locationManager: LocationManaging = LocationManager.shared) {
        self.alarm = alarm
        self.locationManager = locationManager
    }
    
    var etaString: String {
        locationManager.activeAlarmsData[alarm.id.uuidString]?.eta ?? "Menghitung..."
    }
    
    var progress: Double {
        locationManager.activeAlarmsData[alarm.id.uuidString]?.progress ?? 0.0
    }
}
