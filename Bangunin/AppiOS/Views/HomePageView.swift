//
//  HomePageView.swift
//  Bangunin
//
//  Created by Kezia Karen Amelia on 02/07/26.
//

import SwiftData
import SwiftUI

struct HomePageView: View {

    @Query private var alarms: [Alarm]
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = HomePageViewModel()

    @State private var showAddAlarm: Bool = false  // buat create
    @State private var selectedAlarm: Alarm? = nil  // buat edit (update)

    var body: some View {
        NavigationStack {
            ZStack {
                // if else empty state
                if alarms.isEmpty {
                    VStack(spacing: 10) {
                        Image("home illustration")
                            .resizable()
                            .frame(width: 321, height: 321)
                        Text("Belum ada alarm, nih!")
                            .font(.title3)
                            .fontWeight(.bold)
                            .offset(y: -60)
                            .foregroundStyle(Color("new2"))

                        Text("Klik + biar dibangunin di stasiun tujuanmu")
                            .font(.body)
                            .offset(y: -65)
                    }
                    .offset(y: -10)
                } else {
                    List {
                        // active alarm cards (blue)
                        let activeIDs = LocationManager.shared.activeAlarmsData.keys
                        let activeAlarms = alarms.filter { activeIDs.contains($0.id.uuidString) }
                        
                        ForEach(activeAlarms) { activeAlarm in
                            ActiveAlarmCardView(
                                viewModel: ActiveAlarmCardViewModel(alarm: activeAlarm)
                            )
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                            .listRowSeparator(.hidden)
                        }
                            
                        // inactive/waiting alarm cards (white)
                        let inactiveAlarms = alarms.filter { !activeIDs.contains($0.id.uuidString) }
                        
                        ForEach(inactiveAlarms) { alarm in
                            AlarmCardView(
                                viewModel: AlarmCardViewModel(alarm: alarm)
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedAlarm = alarm
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                            .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: deleteAlarms)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .padding(.horizontal)
            .navigationTitle("Alarm")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if !alarms.isEmpty {
                        EditButton()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddAlarm = true
                        AlarmTriggerManager.shared.requestPermissions()
                    } label: {
                        Image(systemName: "plus")
                            .font(.body)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("new2"))
                }
            }
        }
        .sheet(isPresented: $showAddAlarm) {
            AddAlarmView()
        }
        .sheet(item: $selectedAlarm) { alarm in
            AddAlarmView(editingAlarm: alarm)
        }
        .onAppear {
            LocationManager.shared.requestPermission()
        }
        .onReceive(NotificationCenter.default.publisher(for: .banguninAlarmDidCancel)) { notification in
            guard let receivedID = notification.userInfo?["alarmID"] as? String else { return }
            viewModel.handleAlarmCancel(alarmID: receivedID, alarms: alarms, context: modelContext)
        }
    }

    private func deleteAlarms(at offsets: IndexSet) {
        for index in offsets {
            let alarmToDelete = alarms[index]
            viewModel.deleteAlarm(alarmToDelete, context: modelContext)
        }
    }
}

#Preview {
    HomePageView()
        .modelContainer(for: Alarm.self, inMemory: true)
}
