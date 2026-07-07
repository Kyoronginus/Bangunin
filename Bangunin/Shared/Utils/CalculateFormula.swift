//
//  calculateEstimateTime.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 07/07/26.
//

import Foundation

func calculateEstimateTime(distanceInMeters: Double) -> Int {
    let speedKmPerHour: Double = 70.0
    let distanceInKm = distanceInMeters / 1000.0
    
    // Rumus: Waktu (Jam) = Jarak (km) / Kecepatan (km/jam)
    let timeInHours = distanceInKm / speedKmPerHour
    
    // Konversi jam ke menit
    let timeInMinutes = timeInHours * 60.0
    

    return Int(ceil(timeInMinutes))
}
