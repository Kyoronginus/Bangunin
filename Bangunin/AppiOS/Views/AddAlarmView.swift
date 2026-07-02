//
//  AddAlarmView.swift
//  Bangunin
//
//  Created by Kezia Karen Amelia on 02/07/26.
//

import SwiftUI

struct AddAlarmView: View {
    @Environment(\.dismiss) private var dismiss

    // Form state
    @State private var alarmName: String = ""
    @State private var departureStation: String = "None"
    @State private var destinationStation: String = "Palmerah"
    @State private var wakeMeUpAt: String = "5 minutes before"
    @State private var selectedRepeatOptions: Set<String> = []
    @State private var isVibrationOn: Bool = true
    @State private var isSoundOn: Bool = false
    
    let wakeUpTimes = ["At the destination", "5 minutes before", "10 minutes before", "15 minutes before", "20 minutes before", "25 minutes before", "30 minutes before"]
    let repeatOptions = ["Every Sunday", "Every Monday", "Every Tuesday", "Every Wednesday", "Every Thursday", "Every Friday", "Every Saturday"]

    private var repeatText: String {
        let weekdays: Set<String> = ["Every Monday", "Every Tuesday", "Every Wednesday", "Every Thursday", "Every Friday"]
        let weekends: Set<String> = ["Every Saturday", "Every Sunday"]
        
        if selectedRepeatOptions.isEmpty {
            return "Never"
        } else if selectedRepeatOptions.count == repeatOptions.count {
            return "Everyday"
        } else if selectedRepeatOptions == weekdays {
            return "Every Weekday"
        } else if selectedRepeatOptions == weekends {
            return "Every Weekend"
        } else {
            return repeatOptions.filter { selectedRepeatOptions.contains($0) }
                .map { String($0.replacingOccurrences(of: "Every ", with: "").prefix(3)) }
                .joined(separator: ", ")
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
            // top bar
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

                Text("New Alarm")
                    .font(.headline)
                    .bold()

                Spacer()

                Button {
                    // untuk save alarmnya
                } label: {
                    Image(systemName: "checkmark")
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(Color(UIColor.systemBackground))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            ScrollView {
                VStack(spacing: 16) {
                    // Alarm Name
                    TextField("Alarm Name", text: $alarmName)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                    
                    // Stations
                    VStack(spacing: 0) {
                        NavigationLink {
                            RouteSelectionView(isDeparture: true, selectedStation: $departureStation)
                        } label: {
                            HStack {
                                Text("Departure Station")
                                    .foregroundColor(.primary)
                                Spacer()
                                Text(departureStation)
                                    .foregroundColor(.gray)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                    .imageScale(.small)
                            }
                            .padding()
                        }
                        
                        Divider()
                            .padding(.horizontal)
                        
                        NavigationLink {
                            RouteSelectionView(isDeparture: false, selectedStation: $destinationStation)
                        } label: {
                            HStack {
                                Text("Destination Station")
                                    .foregroundColor(.primary)
                                Spacer()
                                Text(destinationStation)
                                    .foregroundColor(.gray)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                    .imageScale(.small)
                            }
                            .padding()
                        }
                    }
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    
                    // Wake me up at
                    HStack {
                        Text("Wake me up at")
                            .foregroundColor(.primary)
                        Spacer()
                        Menu {
                            Picker("Wake me up at", selection: $wakeMeUpAt) {
                                ForEach(wakeUpTimes, id: \.self) { time in
                                    Text(time).tag(time)
                                }
                            }
                        } label: {
                            HStack {
                                Text(wakeMeUpAt)
                                    .foregroundColor(.gray)
                                Image(systemName: "chevron.up.chevron.down")
                                    .foregroundColor(.gray)
                                    .imageScale(.small)
                            }
                        }
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    
                    // Repeat
                    NavigationLink {
                        RepeatSelectionView(selectedRepeatOptions: $selectedRepeatOptions)
                    } label: {
                        HStack {
                            Text("Repeat")
                                .foregroundColor(.primary)
                            Spacer()
                            Text(repeatText)
                                .foregroundColor(.gray)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .imageScale(.small)
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Vibration
                    Toggle("Vibration", isOn: $isVibrationOn)
                        .tint(.green)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                    
                    // Sound
                    Toggle("Sound", isOn: $isSoundOn)
                        .tint(.green)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
    }
}
}

struct RepeatSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedRepeatOptions: Set<String>
    
    let repeatOptions = ["Every Sunday", "Every Monday", "Every Tuesday", "Every Wednesday", "Every Thursday", "Every Friday", "Every Saturday"]

    var body: some View {
        VStack(spacing: 16) {
            // custom top bar matching AddAlarmView
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

                Text("Repeat")
                    .font(.headline)
                    .bold()

                Spacer()
                
                // Invisible view for symmetry
                Color.clear
                    .frame(width: 44, height: 44)
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(repeatOptions.indices, id: \.self) { index in
                        let option = repeatOptions[index]
                        Button {
                            if selectedRepeatOptions.contains(option) {
                                selectedRepeatOptions.remove(option)
                            } else {
                                selectedRepeatOptions.insert(option)
                            }
                        } label: {
                            HStack {
                                Text(option)
                                    .foregroundColor(.primary)
                                Spacer()
                                if selectedRepeatOptions.contains(option) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.orange)
                                        .bold()
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                        }
                        
                        if index < repeatOptions.count - 1 {
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

enum RouteLine: String, CaseIterable {
    case redKotaBogor = "Red Line (Jakarta Kota-Bogor)"
    case redCitayamNambo = "Red Line (Citayam-Nambo)"
    case blue = "Blue Line"
    case green = "Green Line"
    case brown = "Brown Line"
    case pink = "Pink Line"
}

let routeStations: [RouteLine: [String]] = [
    .redKotaBogor: ["Jakarta Kota", "Jayakarta", "Mangga Besar", "Sawah Besar", "Juanda", "Gondangdia", "Cikini", "Manggarai", "Tebet", "Cawang", "Duren Kalibata", "Tanjung Barat", "Lenteng Agung", "Universitas Pancasila", "Universitas Indonesia", "Pondok Cina", "Depok Baru", "Depok", "Citayam", "Cilebut", "Bojong Gede", "Bogor"],
    .redCitayamNambo: ["Citayam", "Pondok Rajeg", "Cibinong", "Nambo"],
    .blue: ["Cikarang", "Metland Telaga Murni", "Cibitung", "Tambun", "Bekasi Timur", "Bekasi", "Kranji", "Cakung", "Klender Baru", "Buaran", "Klender", "Jatinegara", "Matraman", "Manggarai", "Sudirman", "Karet", "Tanah Abang", "Duri", "Angke", "Kampung Bandan", "Rajawali", "Kemayoran", "Pasar Senen", "Gang Sentiong", "Kramat", "Pondok Jati"],
    .green: ["Tanah Abang", "Palmerah", "Kebayoran", "Pondok Ranji", "Jurang Mangu", "Sudimara", "Rawa Buntu", "Serpong", "Cisauk", "Cicayur", "Jatake", "Parung Panjang", "Cilejit", "Daru", "Tenjo", "Tigaraksa", "Cikoya", "Maja", "Citeras", "Rangkasbitung"],
    .brown: ["Tangerang", "Tanah Tinggi", "Batu Ceper", "Poris", "Kalideres", "Rawa Buaya", "Bojong Indah", "Taman Kota", "Pesing", "Grogol", "Duri"],
    .pink: ["Jakarta Kota", "Kampung Bandan", "Ancol", "Tanjung Priok"]
]

struct RouteSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    let isDeparture: Bool
    @Binding var selectedStation: String
    
    let routes: [RouteLine] = [.redKotaBogor, .redCitayamNambo, .blue, .green, .brown, .pink]
    
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

struct StationSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    let route: RouteLine
    @Binding var selectedStation: String
    
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
                    let stations = routeStations[route] ?? []
                    ForEach(stations.indices, id: \.self) { index in
                        let station = stations[index]
                        Button {
                            selectedStation = station
                        } label: {
                            HStack {
                                Text(station)
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

#Preview {
    AddAlarmView()
}
