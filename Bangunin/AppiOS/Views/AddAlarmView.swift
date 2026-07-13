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
    @State private var showDepartureSheet: Bool = false
    @State private var showDestinationSheet: Bool = false
    @State private var showVibrationAlert: Bool = false

    init(editingAlarm: Alarm? = nil) {
        _viewModel = State(
            wrappedValue: AddAlarmViewModel(editingAlarm: editingAlarm)
        )
    }

    var body: some View {
        ZStack {
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

                        Text(viewModel.isEditMode ? "Edit Alarm" : "Alarm Baru")
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
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(viewModel.isFormValid ? Color("new2") : .gray)
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
                            VStack(spacing: 0){
                                // Alarm Berulang
                                HStack{
                                    Text("Alarm Berulang")
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Toggle("", isOn: $viewModel.isRepeating.animation())
                                        .tint(Color("new2"))
                                        .labelsHidden()
                                }
                                .padding()
                                
                                if viewModel.isRepeating {
                                    Divider().padding(.horizontal)
                                    
                                    // Repeat
                                    NavigationLink {
                                        RepeatSelectionView(
                                            selectedRepeatOptions: $viewModel
                                                .selectedRepeatOptions
                                        )
                                    } label: {
                                        HStack {
                                            Image(systemName: "calendar")
                                                .foregroundColor(.white)
                                                .frame(width: 44, height: 44)
                                                .background(Color("new2"))
                                                .clipShape(Circle())
                                            
                                            Text("Ulangi")
                                                .foregroundColor(.primary)
                                            Spacer()
                                            Text(viewModel.repeatText)
                                                .foregroundColor(.gray)
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                    }
                                }
                            }
                            .background(.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            
                            // Stations
                            if !viewModel.isRepeating {
                                Button {
                                    showDestinationSheet.toggle()
                                } label: {
                                    HStack(spacing: 16) {
                                        Image(systemName: "anchor")
                                            .foregroundColor(.white)
                                            .frame(width: 44, height: 44)
                                            .background(Color("new2"))
                                            .clipShape(Circle())
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Turun di")
                                                .foregroundColor(.primary)
                                            Text(viewModel.destinationStation.name == Station.none.name ? "Pilih" : viewModel.destinationStation.name)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                            .imageScale(.small)
                                    }
                                    .padding()
                                }
                                .background(.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                                .sheet(isPresented: $showDestinationSheet) {
                                    NavigationStack {
                                        UnifiedStationSelectionView(
                                            title: "Pilih Stasiun",
                                            stations: viewModel.allStations,
                                            selectedStation: $viewModel.destinationStation
                                        )
                                    }
                                    .presentationDragIndicator(.visible)
                                }
                            } else {
                                VStack(spacing: 0) {
                                    Text("Alarm otomatis aktif begitu kamu naik dari sini")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(Color("new2").opacity(0.8))
                                    
                                    Button {
                                        showDepartureSheet.toggle()
                                    } label: {
                                        HStack(spacing: 16) {
                                            Image(systemName: "paperplane.fill")
                                                .foregroundColor(.white)
                                                .frame(width: 44, height: 44)
                                                .background(Color("new2"))
                                                .clipShape(Circle())
                                            
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text("Berangkat dari")
                                                    .foregroundColor(.primary)
                                                Text(viewModel.departureStation.name == Station.none.name ? "Pilih" : viewModel.departureStation.name)
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                                .imageScale(.small)
                                        }
                                        .padding()
                                    }
                                    .sheet(isPresented: $showDepartureSheet) {
                                        NavigationStack{
                                            UnifiedStationSelectionView(
                                                title: "Pilih Stasiun",
                                                stations: viewModel.allStations,
                                                selectedStation: $viewModel.departureStation
                                            )
                                        }
                                        .presentationDragIndicator(.visible)
                                    }

                                    Divider()
                                        .padding(.horizontal)

                                    Button {
                                        showDestinationSheet.toggle()
                                    } label: {
                                        HStack(spacing: 16) {
                                            Image(systemName: "anchor")
                                                .foregroundColor(.white)
                                                .frame(width: 44, height: 44)
                                                .background(Color("new2"))
                                                .clipShape(Circle())
                                            
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text("Turun di")
                                                    .foregroundColor(.primary)
                                                Text(viewModel.destinationStation.name == Station.none.name ? "Pilih" : viewModel.destinationStation.name)
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                                .imageScale(.small)
                                        }
                                        .padding()
                                    }
                                    .disabled(viewModel.departureStation.name == Station.none.name)
                                    .opacity(viewModel.departureStation.name == Station.none.name ? 0.5 : 1.0)
                                    .sheet(isPresented: $showDestinationSheet) {
                                        NavigationStack {
                                            UnifiedStationSelectionView(
                                                title: "Pilih Stasiun",
                                                stations: viewModel.getAvailableDestinations(for: viewModel.departureStation),
                                                selectedStation: $viewModel.destinationStation
                                            )
                                        }
                                        .presentationDragIndicator(.visible)
                                    }
                                }
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color("new2").opacity(0.8), lineWidth: 1)
                                )
                                .onChange(of: viewModel.departureStation.name) { _, _ in
                                    let validDestinations = viewModel.getAvailableDestinations(for: viewModel.departureStation)
                                    if !validDestinations.contains(where: { $0.name == viewModel.destinationStation.name }) {
                                        viewModel.destinationStation = .none
                                    }
                                }
                            }

                            // Wake me up at
                            HStack(spacing: 16) {
                                Image(systemName: "alarm.fill")
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(Color("new2"))
                                    .clipShape(Circle())

                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Bangunin Aku")
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    
                                    Text(viewModel.wakeMeUpAt.rawValue)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Menu {
                                    Picker("Wake me up at", selection: $viewModel.wakeMeUpAt) {
                                        ForEach(WakeUpTime.allCases, id: \.self) { time in
                                            Text(time.rawValue).tag(time)
                                        }
                                    }
                                } label: {
                                    Image(systemName: "chevron.up.chevron.down")
                                        .foregroundColor(.gray)
                                        .imageScale(.small)
                                        .frame(width: 44, height: 44)
                                        .contentShape(Rectangle())
                                }
                            }
                            .padding()
                            .background(.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            
                            // pengaturan alarm
                            Text("Pengaturan Alarm")
                                .frame(maxWidth: .infinity, alignment: .leading)

                            HStack{
                                Image(systemName: "speaker.wave.3.fill")
                                    .foregroundColor(.white)
                                    .frame(width:44, height: 44)
                                    .background(Color("new2"))
                                    .clipShape(Circle())
                                
                                Text("Suara")
                                Spacer()
                                Toggle("", isOn: $viewModel.isSoundOn)
                                    .tint(Color("new2"))
                                    .labelsHidden()
                                    .onChange(of: viewModel.isSoundOn) {_, newValue in
                                        if !newValue {
                                            showVibrationAlert = true
                                        }
                                    }
                            }
                            .padding()
                            .background(.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            
                        }
                        .padding(.horizontal)
                    }
                }
                .navigationBarHidden(true)
                .background(
                    LinearGradient(
                        colors: [Color("new2").opacity(0.2), Color.cyan.opacity(0.1)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .blur(radius: showVibrationAlert ? 3 : 0)
            
            if showVibrationAlert {
                VibrationAlertView {
                    withAnimation{
                        showVibrationAlert = false
                    }
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Alarm.self, configurations: config)
        return AddAlarmView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview container: \(error.localizedDescription)")
    }
}
