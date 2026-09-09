//
//  BanguninTests.swift
//  BanguninTests
//
//  Created by Tohru Djunaedi Sato on 04/09/26.
//

import Testing
@testable import Bangunin

struct AddAlarmViewModelTests {
    
    // UT-001 (Positive)
    @Test("isFormValid returns true for one-time valid alarm")
    func test_isFormValid_oneTimeValidAlarm() {
        let viewModel = AddAlarmViewModel()
        let manggarai = Station(name: "Manggarai", latitude: -6.2098, longitude: 106.8502)
        viewModel.isRepeating = false
        viewModel.destinationStation = manggarai
        
        #expect(viewModel.isFormValid == true)
    }

    // UT-002 (negative)
    @Test("isFormValid returns false if departure and destination station are same")
    func test_isFormValid_repeatedAlarmWithSameStation() {
        let viewModel = AddAlarmViewModel()
        let manggarai = Station(name: "Manggarai", latitude: -6.2098, longitude: 106.8502)
        viewModel.isRepeating = true
        viewModel.departureStation = manggarai
        viewModel.destinationStation = manggarai
        
        #expect(viewModel.isFormValid == false)
    }
    
    // UT-003
    @Test("repeatText formats correctly")
    func test_repeatText_formatMultipleDays(){
        let viewModel = AddAlarmViewModel()
        viewModel.selectedRepeatOptions = [.monday, .tuesday, .saturday]
        
        #expect(viewModel.repeatText == "Sen, Sel, Sab")
    }
    
    @Test("repeatText formats Weekday correctly")
    func test_repeatText_formatWeekday(){
        let viewModel = AddAlarmViewModel()
        viewModel.selectedRepeatOptions = [.monday, .tuesday, .wednesday, .thursday, .friday]
        
        #expect(viewModel.repeatText == "Setiap Hari Kerja")
    }
    
    @Test("repeatText formats Weekend correctly")
    func test_repeatText_formatWeekend(){
       let viewModel = AddAlarmViewModel()
       viewModel.selectedRepeatOptions = [.saturday, .sunday]
       
       #expect(viewModel.repeatText == "Setiap Hari Libur")
    }
    
    @Test("repeatText formats Everyday correctly")
    func test_repeatText_formatEveryday(){
        let viewModel = AddAlarmViewModel()
        viewModel.selectedRepeatOptions = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        
        #expect(viewModel.repeatText == "Setiap Hari")
    }
    
    
    // UT-004
    @Test("fetch allStations twice and check the orders")
    func test_fetchAllStations_isOrderFixed() {
        let viewModel = AddAlarmViewModel()
        let stations1 = viewModel.allStations
        let stations2 = viewModel.allStations
        
        #expect(stations1 == stations2)
    }
    
    
    
    
}
