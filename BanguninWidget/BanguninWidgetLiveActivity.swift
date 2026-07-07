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
                Text("to \(context.attributes.destinationStationName)")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.cyan)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                Spacer(minLength: 4)
                
                if #available(iOS 17.0, *) {
                    // UBAH: Masukkan alarmID dari context
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

                    Text("Alarm Active")
                        .font(.title2)
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
                }

                // Custom Progress Bar Mockup
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 6)

                        Capsule()
                            .fill(Color.cyan)
                            .frame(
                                width: geometry.size.width
                                    * context.state.progress,
                                height: 6
                            )

                        Image(systemName: "tram.fill")
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.black)
                            .clipShape(Circle())
                            .offset(
                                x: (geometry.size.width * context.state.progress)
                                    - 12
                            )

                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .background(Color.white)
                            .clipShape(Circle())
                            .offset(x: geometry.size.width - 10)
                    }
                }
                .frame(height: 24)

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
            }
            .padding()
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

struct AlarmKitLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AlarmKit.AlarmAttributes<EmptyMetadata>.self)
        { context in
            VStack {
                Text("Alarm Triggered!")
                    .font(.headline)
            }
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("Alarm")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Active")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Time to wake up!")
                }
            } compactLeading: {
                Text("⏰")
            } compactTrailing: {
                Text("!")
            } minimal: {
                Text("⏰")
            }
        }
    }
}
