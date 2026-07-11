//
//  UnifiedStationSelectionView.swift
//  Bangunin
//
//  Created by Kezia Karen Amelia on 09/07/26.
//

import SwiftUI

struct UnifiedStationSelectionView: View {
    @Environment(\.dismiss) private var dismiss

    let title: String
    @Binding var selectedStation: Station
    @State private var viewModel: StationSelectionViewModel

    init(title: String, stations: [Station], selectedStation: Binding<Station>)
    {
        self.title = title
        self._selectedStation = selectedStation
        self._viewModel = State(
            wrappedValue: StationSelectionViewModel(stations: stations)
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            List {
                
                

                //                    Section {
                //                        EmptyView()
                //                    } header: {
                //                        EmptyView()
                //                    }
                //                    .sectionIndexLabel("X")
                //
                ////                    ForEach(viewModel.groupedStations, id: \.0) { group in
                ////                        // If []
                ////                        Section(header: Text(group.0)) {
                ////                            ForEach(group.1, id: \.name) { station in
                ////                                stationRow(for: station)
                ////                            }
                ////                        }
                ////                        .sectionIndexLabel(group.0)
                ////                    }
                //
                //                    ForEach(viewModel.filteredIndexedStation, id: \.0) { station in
                //
                //                        let index = station.0
                //                        let stations = station.1
                //
                //                        Section(header: Text(index)) {
                //                            ForEach(stations, id: \.name) { station in
                //                                stationRow(for: station)
                //                            }
                //                        }
                //                    }
                //
                //
                //                } else {
                ////                    ForEach(
                ////                        viewModel.filteredStations.sorted(by: {
                ////                            $0.name < $1.name
                ////                        }),
                ////                        id: \.name
                ////                    ) { station in
                ////                        stationRow(for: station)
                ////                    }
                //                    ForEach(viewModel.indexedStations, id: \.self) { station in
                //                        stationRow(for: station.0)
                //                    }

                ForEach(viewModel.filteredIndexedStations, id: \.0) { group in
                    let index = group.0
                    let stationsInGroup = group.1
                    
                    Section(header: Text(index)) {
                        ForEach(stationsInGroup, id: \.name) { station in
                            stationRow(for: station)
                        }
                    }
                    .sectionIndexLabel(index)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $viewModel.searchText, prompt: "Search Station")
    }

    private func stationRow(for station: Station) -> some View {
        Button {
            selectedStation = station
            dismiss()
        } label: {
            HStack {
                Text(station.name)
                    .foregroundColor(.primary)
                Spacer()
                if selectedStation.name == station.name {
                    Image(systemName: "checkmark")
                        .foregroundColor(.orange)
                        .bold()
                }
            }
        }
    }
}
