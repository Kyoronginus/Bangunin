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
    
    
    // Menghitung total jarak dari stasiun keberangkatan ke stasiun tujuan (dalam meter)
    private var totalDistance: Double? {
        guard let departure = findStation(name: alarm.departureStation),
              let destination = findStation(name: alarm.destinationStation) else {
            return nil
        }
        
        let depLoc = CLLocation(latitude: departure.coordinate.latitude, longitude: departure.coordinate.longitude)
        let destLoc = CLLocation(latitude: destination.coordinate.latitude, longitude: destination.coordinate.longitude)
        
        return depLoc.distance(from: destLoc)
    }
    
    // Mendapatkan sisa jarak dari lokasi user saat ini ke stasiun tujuan
    private var distanceToDestination: Double? {
        guard let destination = findStation(name: alarm.destinationStation) else { return nil }
        
        // Memanggil helper dari LocationManager yang otomatis ter-update karena LocationManager juga @Observable
        return LocationManager.shared.distanceTo(destinationCoordinate: destination.coordinate)
    }
    
    // Estimasi waktu (menit) yang akan ditampilkan di View
    var estimatedMinutesRemaining: Int {
        guard let distanceToDestination else { return 0 }
        return calculateEstimateTime(distanceInMeters: distanceToDestination)
    }
    
    // Progress kereta (0.0 sampai 1.0) yang akan ditampilkan di View
    var progress: Double {
        guard let total = totalDistance, let remaining = distanceToDestination, total > 0 else {
            return 0.0
        }
        
        let traveledDistance = total - remaining
        let currentProgress = traveledDistance / total
        
        return min(max(currentProgress, 0.0), 1.0)
    }
}
