//
//  BanguninWidgetLiveActivity.swift
//  BanguninWidget
//

import ActivityKit
import AlarmKit
import AppIntents
import SwiftUI
import WidgetKit

struct BanguninWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BanguninAlarmAttributes.self) { context in
            WatchOrPhoneView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("Alarm")
                        .font(.caption)
                        .foregroundColor(.cyan)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.attributes.destinationStationName)
                        .font(.caption)
                        .lineLimit(1)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Spacer()
                        // UBAH: Masukkan alarmID dari context
                        CancelButtonView(alarmID: context.attributes.alarmID)
                        Spacer()
                    }
                }
            } compactLeading: {
                Image(systemName: "tram.fill")
                    .foregroundColor(.cyan)
            } compactTrailing: {
                Text("Active")
                    .foregroundColor(.red)
            } minimal: {
                Image(systemName: "tram.fill")
                    .foregroundColor(.cyan)
            }
        }
        .supplementalActivityFamilies([.small])
    }
}

struct WatchOrPhoneView: View {
    let context: ActivityViewContext<BanguninAlarmAttributes>
    @Environment(\.activityFamily) var activityFamily

    var body: some View {
        if activityFamily == .small {
            VStack(alignment: .leading, spacing: 2) {
                Text("Menuju \(context.attributes.destinationStationName)")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.cyan)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                Spacer(minLength: 4)
                
                if #available(iOS 17.0, *) {
                    // Masukkan alarmID dari context
                    Button(intent: CancelAlarmIntent(alarmID: context.attributes.alarmID)) {
                        Text("Cancel Alarm")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.15))
                    .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .activityBackgroundTint(Color.black.opacity(0.8))
            .activitySystemActionForegroundColor(Color.white)

        } else {
            // iPhone Lock Screen / Banner UI
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("BANGUNIN")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .textCase(.uppercase)
                        // .padding(.top, 11)
                        .padding(.bottom, 4)

                    Text("Santai aja, tinggal istirahat")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    HStack(spacing: 4) {
                        Text("to")
                            .foregroundColor(.gray)
                        Text(context.attributes.destinationStationName)
                            .foregroundColor(.cyan)
                            .fontWeight(.bold)
                    }
                    .font(.subheadline)
                }.padding(.bottom, -3)

                // Custom Progress Bar Component
                TrainProgressBar(progress: context.state.progress, tintColor: .cyan)
                    .padding(.vertical, 8)
                
                

                // Cancel Button
                HStack {
                    Spacer()
                    // UBAH: Masukkan alarmID dari context
                    Button(intent: CancelAlarmIntent(alarmID: context.attributes.alarmID)) {
                        Text("Cancel Alarm")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.plain)
                    .background(Color.white.opacity(0.15))
                    .clipShape(Capsule())
                    Spacer()
                }
                .padding(.bottom, 1)
            }
            .padding()
            // .padding(.bottom, 6)
            .activityBackgroundTint(Color.black.opacity(0.8))
            .activitySystemActionForegroundColor(Color.white)
        }
    }
}

struct CancelButtonView: View {
    let alarmID: String
    
    var body: some View {
        // UBAH: Masukkan alarmID yang dikirim dari Struct di atas
        Button(intent: CancelAlarmIntent(alarmID: alarmID)) {
            Text("Cancel")
                .font(.subheadline)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
        .background(Color.white.opacity(0.2))
        .clipShape(Capsule())
    }
}

