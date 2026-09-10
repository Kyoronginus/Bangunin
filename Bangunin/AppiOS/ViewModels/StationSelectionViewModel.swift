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
    var searchText: String = ""

    init(stations: [Station]) {
        self.stations = stations
    }

    var filteredStations: [Station] {
        if searchText.isEmpty {
            return stations
        } else {
            return stations.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var groupedStations: [String: [Station]] {
        Dictionary(grouping: filteredStations) { station in
            String(station.name.prefix(1)).uppercased()
        }
    }
}
