//
//  RouteSelectionView.swift
//  Bangunin
//

import SwiftUI

struct RouteSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    let isDeparture: Bool
    @Binding var selectedStation: String
    
    let routes = RouteLine.allCases
    
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

                Text(isDeparture ? "Departure Station" : "Destination Station")
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
                    if isDeparture {
                        Button {
                            selectedStation = "None"
                        } label: {
                            HStack {
                                Text("None")
                                    .foregroundColor(.primary)
                                Spacer()
                                if selectedStation == "None" {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.orange)
                                        .bold()
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                        }
                        
                        Divider()
                            .padding(.horizontal)
                    }
                    
                    ForEach(routes.indices, id: \.self) { index in
                        let route = routes[index]
                        NavigationLink {
                            StationSelectionView(route: route, selectedStation: $selectedStation)
                        } label: {
                            HStack {
                                Text(route.rawValue)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                    .imageScale(.small)
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                        }
                        
                        if index < routes.count - 1 {
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
