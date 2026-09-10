//
//  StationSelectionViewModelTests.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 10/09/26.
//

import Testing
@testable import Bangunin

struct StationSelectionViewModelTests {
    
    private let sampleStations = [
        Station(name: "Jakarta Kota", latitude: -6.1375, longitude: 106.8146),
        Station(name: "Jayakarta", latitude: -6.1413, longitude: 106.8206),
        Station(name: "Mangga Besar", latitude: -6.1497, longitude: 106.8248),
        Station(name: "Sawah Besar", latitude: -6.1607, longitude: 106.8277),
        Station(name: "Juanda", latitude: -6.1666, longitude: 106.8281),
        Station(name: "Gondangdia", latitude: -6.1860, longitude: 106.8326),
        Station(name: "Cikini", latitude: -6.1985, longitude: 106.8407),
        Station(name: "Manggarai", latitude: -6.2098, longitude: 106.8502),
        Station(name: "Tebet", latitude: -6.2263, longitude: 106.8576),
        Station(name: "Cawang", latitude: -6.2427, longitude: 106.8587),
        Station(name: "Duren Kalibata", latitude: -6.2555, longitude: 106.8548),
        Station(name: "Tanjung Barat", latitude: -6.3051, longitude: 106.8398),
        Station(name: "Lenteng Agung", latitude: -6.3312, longitude: 106.8344),
        Station(name: "Universitas Pancasila", latitude: -6.3392, longitude: 106.8329),
        Station(name: "Universitas Indonesia", latitude: -6.3609, longitude: 106.8317)
    ]
    
    
    @Test("filteredStations returns all stations when searchText is empty")
    func test_filteredStations_whenSearchTextEmpty_returnsAllStations() {
        let viewModel = StationSelectionViewModel(stations: sampleStations)
        viewModel.searchText = ""
        
        #expect(viewModel.filteredStations.count == sampleStations.count)
        #expect(viewModel.filteredStations == sampleStations)
    }
    
    @Test("filteredStations matches case-insensitively")
    func test_filteredStations_caseInsensitive() {
        let viewModel = StationSelectionViewModel(stations: sampleStations)
        
        viewModel.searchText = "caw"
        #expect(viewModel.filteredStations.map(\.name) == ["Cawang"])
        
        viewModel.searchText = "TANJUNG"
        #expect(viewModel.filteredStations.map(\.name) == ["Tanjung Barat"])
    }
    
    @Test("filteredStations matches substrings")
    func test_filteredStations_substring() {
        let viewModel = StationSelectionViewModel(stations: sampleStations)
        viewModel.searchText = "Pancasi"
        #expect(viewModel.filteredStations.map(\.name) == ["Universitas Pancasila"])
    }
    
    @Test("filteredStations returns empty when no station matches searchText")
    func test_filteredStations_whenNoMatch_returnsEmpty() {
        let viewModel = StationSelectionViewModel(stations: sampleStations)
        viewModel.searchText = "aoiwjeroiajsoijb230923j490jsdg"
        #expect(viewModel.filteredStations.isEmpty)
    }
    
    @Test("groupedStations groups stations alphabetically by uppercase first character")
    func test_groupedStations_groupsAlphabetically() {
        let viewModel = StationSelectionViewModel(stations: sampleStations)
        let groups = viewModel.groupedStations
        
        let expectedKeys = ["C", "D", "G", "J", "L", "M", "S", "T", "U"]
        #expect(groups.keys.sorted() == expectedKeys)
        
        #expect(groups["J"]?.count == 3)
        #expect(groups["C"]?.count == 2)
        #expect(groups["M"]?.count == 2)
        #expect(groups["T"]?.count == 2)
        #expect(groups["U"]?.count == 2)
//        #expect(groups["G"]?.count == ["Gondangdia"])
        
        let jGroupNames = groups["J"]?.map(\.name) ?? []
        #expect(jGroupNames.contains("Jakarta Kota"))
        #expect(jGroupNames.contains("Jayakarta"))
        #expect(jGroupNames.contains("Juanda"))
    }
    
    @Test("groupedStations only groups stations present in filteredStations")
    func test_groupedStations_onlyGroupsFilteredStations() {
        let viewModel = StationSelectionViewModel(stations: sampleStations)
        viewModel.searchText = "Besar"
        let groups = viewModel.groupedStations
        
        #expect(groups.keys.sorted() == ["M","S"])
        #expect(groups["M"]?.map(\.name) == ["Mangga Besar"])
        #expect(groups["S"]?.map(\.name) == ["Sawah Besar"])
        #expect(groups["A"] == nil)
    }
}
