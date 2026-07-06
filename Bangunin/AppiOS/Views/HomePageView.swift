//
//  HomePageView.swift
//  Bangunin
//
//  Created by Kezia Karen Amelia on 02/07/26.
//

import SwiftUI
import SwiftData

struct HomePageView: View {

    @Query private var alarms: [Alarm]
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = HomePageViewModel()

    @State private var showAddAlarm: Bool = false // buat create
    @State private var selectedAlarm: Alarm? = nil // buat edit (update)

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
                        ForEach(alarms) { alarm in
                            AlarmCardView(viewModel: AlarmCardViewModel(alarm: alarm))
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedAlarm = alarm
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) { //delete alarm kalau di swipe
                                    Button(role: .destructive) {
                                        viewModel.deleteAlarm(alarm, context: modelContext)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
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
            AlarmTriggerManager.shared.requestPermissions()
            LocationManager.shared.requestPermission()
        }
    }

}

#Preview {
    HomePageView()
        .modelContainer(for: Alarm.self, inMemory: true)
}
