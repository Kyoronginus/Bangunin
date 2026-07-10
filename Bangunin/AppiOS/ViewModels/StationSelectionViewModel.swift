//
//  StationSelectionViewModel.swift
//  Bangunin
//
//  Created by Kezia Karen Amelia on 09/07/26.
//

import Foundation

@Observable
class StationSelectionViewModel {
    var stations: [Station]
    var indexedStations: [String: [Station]] = [:]
    var searchText: String = ""

    init(stations: [Station]) {
        self.stations = stations
        indexStation()
    }

    var filteredStations: [Station] {
        if searchText.isEmpty {
            return stations
        } else {
            return stations.filter {
                $0.name.localizedStandardContains(searchText)
            }
        }
    }
    
    func indexStation() {
        for station in stations {
            if let index = station.name.first?.uppercased() {
                if indexedStations[index] == nil {
                    indexedStations[index] = [station]
                }
                else {
                    indexedStations[index]?.append(station)
                }
            }
        }
        
        // Sort the dictionary.
//        for (index, stations) in indexedStations {
//            let sorted = stations.sorted{ $0.name.localizedCapitalized < $1.name.localizedCapitalized }
//            // Masukin balik
//        }
    }
//    var groupedStations: [(String, [Station])] {
//        let grouped = Dictionary(grouping: filteredStations) { station in
//            String(station.name.prefix(1)).uppercased()
//        }
//        return grouped.map {
//            ($0.key, $0.value.sorted(by: { $0.name < $1.name }))
//        }
//        .sorted { $0.0 < $1.0 }
//    }
}
