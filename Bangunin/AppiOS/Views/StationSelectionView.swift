//
//  StationSelectionView.swift
//  Bangunin
//

import SwiftUI

struct StationSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    let route: RouteLine
    @Binding var selectedStation: Station
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(Color(UIColor.systemBackground))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                }

                Spacer()

                Text(route.rawValue)
                    .font(.headline)
                    .bold()

                Spacer()
                
                Color.clear
                    .frame(width: 44, height: 44)
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            ScrollView {
                VStack(spacing: 0) {
                    let stations = RouteData.routeStations[route] ?? []
                    ForEach(stations.indices, id: \.self) { index in
                        let station = stations[index]
                        Button {
                            selectedStation = station
                        } label: {
                            HStack {
                                Text(station.name)
                                    .foregroundColor(.primary)
                                Spacer()
                                if selectedStation == station {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.orange)
                                        .bold()
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                        }
                        
                        if index < stations.count - 1 {
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                }
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
    }
}
