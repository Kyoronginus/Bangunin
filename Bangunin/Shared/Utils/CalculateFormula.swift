//
//  calculateEstimateTime.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 07/07/26.
//

import Foundation

func calculateEstimateTime(distanceInMeters: Double) -> Int {
    
    // Call the overloaded function below, forcing it to use 70.0 km/h
    return calculateEstimateTime(distanceInMeters: distanceInMeters, speedKmPerHour: 70.0)
}

func calculateEstimateTime(distanceInMeters: Double, speedKmPerHour: Double) -> Int {
    
    let distanceInKm = distanceInMeters / 1000.0
    
    let speed = abs(speedKmPerHour)
    let safespeed = speed > 0 ? speed : 70.0
    
    // Rumus: Waktu (Jam) = Jarak (km) / Kecepatan (km/jam)
    let timeInHours = distanceInKm / safespeed
    
    // Konversi jam ke menit
    let timeInMinutes = timeInHours * 60.0
    
    return Int(ceil(timeInMinutes))
}


