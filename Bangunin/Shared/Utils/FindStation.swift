//
//  findStation.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 05/07/26.
//

func findStation(name: String) -> Station? {
    for (_, stations) in RouteData.routeStations {
        if let found = stations.first(where: { $0.name == name }) {
            return found
        }
    }
    return nil
}
