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
        ZStack {
            VStack {
                // top bar
                HStack {
                    Button {

                    } label: {
                        Text("Edit")
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(.gray.opacity(0.2))
                            .clipShape(Capsule())
                    }

                    Spacer()

                    Button {
                        showAddAlarm = true
                        AlarmTriggerManager.shared.requestPermissions()
                    } label: {
                        Image(systemName: "plus")
                            .frame(width: 40, height: 40)
                            .background(.gray.opacity(0.2))
                            .clipShape(Circle())
                    }

                }
                .padding(.horizontal)

                // title
                HStack {
                    Text("Alarms")
                        .font(.system(size: 40, weight: .bold))

                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)

                Spacer()

                // if else empty state
                if alarms.isEmpty {
                    VStack(spacing: 10) {
                        Text("No alarms yet")
                            .font(.title2)
                            .fontWeight(.medium)

                        Text("Click the + button to add your alarm")
                            .font(.body)
                            .fontWeight(.regular)
                    }
                } else {
                    List {
                        // active alarm card view
                        if let activeID = LocationManager.shared.activeAlarmID,
                           let activeAlarm = alarms.first(where: { $0.id.uuidString == activeID }) {
                            ActiveAlarmCardView(
                                viewModel: ActiveAlarmCardViewModel(alarm: activeAlarm)
                            )
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                            .listRowSeparator(.hidden)
                        }
                            
                        ForEach(alarms) { alarm in
                            AlarmCardView(
                                viewModel: AlarmCardViewModel(alarm: alarm)
                            )
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedAlarm = alarm
                            }
                            .swipeActions(
                                edge: .trailing,
                                allowsFullSwipe: true
                            ) {  //delete alarm kalau di swipe
                                Button(role: .destructive) {
                                    viewModel.deleteAlarm(
                                        alarm,
                                        context: modelContext
                                    )
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }

                Spacer()
            }
            .padding(.all)
            .ignoresSafeArea(edges: .bottom)
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
                    if let activeAlarm = alarms.first(where: { $0.id.uuidString == receivedID }) {
                        activeAlarm.isActive = false
                        do {
                            try modelContext.save()
                            print("Alarm berhasil dimatikan dari Live Activity/AlarmKit.")
                        } catch {
                            print("Gagal menyimpan update alarm ke database: \(error)")
                        }
                    }
                }
    }

}

#Preview {
    HomePageView()
        .modelContainer(for: Alarm.self, inMemory: true)
}
