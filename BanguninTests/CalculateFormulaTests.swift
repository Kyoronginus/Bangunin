//
//  CalculateFormulaTests.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 04/09/26.
//

import Testing
@testable import Bangunin

struct CalculateFormulaTests {
    @Test("ETA calculation without passing velocity")
    func test_etaWithoutVelocity() {
        let distance: Double = 5000
        let eta = calculateEstimateTime(distanceInMeters: distance)
        
        // expects the function to use fall back value
        #expect(eta > 0)
    }
    
    @Test("ETA calculation with passing positive velocity")
    func test_etaWithPositiveVelocity() {
        let distance: Double =  5000
        let eta = calculateEstimateTime(distanceInMeters: distance, speedKmPerHour: 10)
        
        #expect(eta > 0)
    }
    
    @Test("ETA calculation with passing 0 as the velocity")
    func test_etaWithZeroVelocity() {
        let distance: Double = 5000
        let eta = calculateEstimateTime(distanceInMeters: distance, speedKmPerHour: 0)
        
        // should provide edge case handling if the input was 0
        #expect(eta > 0)
    }
    @Test("ETA calculation with passing negative velocity")
    func test_etaWithNegativeVelocity() {
        let distance: Double = 5000
        let eta = calculateEstimateTime(distanceInMeters: distance, speedKmPerHour: -10.0)
        
        // expects the function to use fall back value
        #expect(eta > 0)
    }
}
