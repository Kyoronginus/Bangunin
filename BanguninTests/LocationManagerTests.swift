//
//  LocationManagerTests.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 04/09/26.
//

import Testing
@testable import Bangunin

struct LocationManagerTests{
    
    // happy path
    @Test("String parsing on regionIdentifier successful")
    func test_regionIdentifierValidParsing() throws {
        
        let validString = "departure|1234-5678|Manggarai|JakartaKota"
        
        let regionId = RegionIdentifier(stringValue: validString)
        let unwrappedRegion = try #require(regionId)
        
        #expect(unwrappedRegion.purpose == .departure)
        #expect(unwrappedRegion.alarmID == "1234-5678")
        #expect(unwrappedRegion.stationName == "Manggarai")
        #expect(unwrappedRegion.targetDestination == "JakartaKota")
    }
    
    //negative path
    @Test("String parsing on regionIdentifier failed")
    func test_regionIdentifierInvalidParsing() throws {
        
        let invalidString = "departure|1234-5678"
        
        let regionId = RegionIdentifier(stringValue: invalidString)
        
        #expect(regionId == nil, "initialization must fail when the string is invalid")
    }
    
    
}
