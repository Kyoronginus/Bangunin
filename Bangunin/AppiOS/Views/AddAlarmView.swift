//
//  AddAlarmView.swift
//  Bangunin
//
//  Created by Kezia Karen Amelia on 02/07/26.
//

import SwiftData
import SwiftUI

struct AddAlarmView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var viewModel: AddAlarmViewModel

    init(editingAlarm: Alarm? = nil) {
        _viewModel = State(
            wrappedValue: AddAlarmViewModel(editingAlarm: editingAlarm)
        )
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
                            .shadow(
                                color: .black.opacity(0.05),
                                radius: 5,
                                x: 0,
                                y: 2
                            )
                    }

                    Spacer()

                    Text(viewModel.isEditMode ? "Edit Alarm" : "New Alarm")
                        .font(.headline)
                        .bold()

                    Spacer()

                    Button {
                        if viewModel.isFormValid {
                            viewModel.saveAlarm(context: modelContext)
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundColor(
                                viewModel.isFormValid
                                    ? .primary : .gray.opacity(0.3)
                            )
                            .frame(width: 44, height: 44)
                            .background(Color(UIColor.systemBackground))
                            .clipShape(Circle())
                            .shadow(
                                color: .black.opacity(0.05),
                                radius: 5,
                                x: 0,
                                y: 2
                            )
                    }
                    .disabled(!viewModel.isFormValid)
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 8)

                ScrollView {
                    VStack(spacing: 16) {
                        // Alarm Name
                        TextField("Alarm Name", text: $viewModel.alarmName)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)

                        // Stations
                        VStack(spacing: 0) {
                            NavigationLink {
                                UnifiedStationSelectionView( // unified station
                                    title: "Departure Station",
                                    stations: viewModel.allStations,
                                    selectedStation: $viewModel.departureStation
                                )
                            } label: {
                                HStack {
                                    Text("Departure Station")
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text(viewModel.departureStation.name)
                                        .foregroundColor(.gray)
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .imageScale(.small)
                                }
                                .padding()
                            }

                            Divider()
                                .padding(.horizontal)
                            
                            if viewModel.departureStation.name
                                != Station.none.name
                            {
                                NavigationLink {
                                    UnifiedStationSelectionView(
                                        title: "Destination Station",
                                        stations:
                                            viewModel.getAvailableDestinations(
                                                for: viewModel.departureStation
                                            ),
                                        selectedStation: $viewModel
                                            .destinationStation
                                    )
                                } label: {
                                    HStack {
                                        Text("Destination Station")
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Text(viewModel.destinationStation.name)
                                            .foregroundColor(.gray)
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                            .imageScale(.small)
                                    }
                                    .padding()
                                }
                            } else {
                                HStack {
                                    Text("Destination Station")
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text("Select Departure First")
                                        .foregroundColor(.gray)
                                        .italic()
                                }
                                .padding()
                                .opacity(0.5)
                            }
                        }
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(12)
                        .onChange(of: viewModel.departureStation.name) { _, _ in // cek apakah ada di line yg valid (kalau user ganti departure station)
                            let validDestinations =
                                viewModel.getAvailableDestinations(
                                    for: viewModel.departureStation
                                )
                            if !validDestinations.contains(where: {
                                $0.name == viewModel.destinationStation.name
                            }) {
                                viewModel.destinationStation = .none
                            }
                        }

                        // Wake me up at
                        HStack {
                            Text("Wake me up at")
                                .foregroundColor(.primary)
                            Spacer()
                            Menu {
                                Picker(
                                    "Wake me up at",
                                    selection: $viewModel.wakeMeUpAt
                                ) {
                                    ForEach(WakeUpTime.allCases, id: \.self) {
                                        time in
                                        Text(time.rawValue).tag(time)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(viewModel.wakeMeUpAt.rawValue)
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
                            RepeatSelectionView(
                                selectedRepeatOptions: $viewModel
                                    .selectedRepeatOptions
                            )
                        } label: {
                            HStack {
                                Text("Repeat")
                                    .foregroundColor(.primary)
                                Spacer()
                                Text(viewModel.repeatText)
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
                        Toggle("Vibration", isOn: $viewModel.isVibrationOn)
                            .tint(.green)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)

                        // Sound
                        Toggle("Sound", isOn: $viewModel.isSoundOn)
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

#Preview {
    AddAlarmView()
}
