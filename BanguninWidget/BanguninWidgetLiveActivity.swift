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
                        CancelButtonView(alarmID: context.attributes.alarmID)
                        Spacer()
                    }
                }
            } compactLeading: {
                Image(systemName: "tram.fill")
                    .foregroundColor(Color("new2"))
            } compactTrailing: {
                Text("Active")
                    .foregroundColor(.red)
            } minimal: {
                Image(systemName: "tram.fill")
                    .foregroundColor(Color("new2"))
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
                    Button(intent: CancelAlarmIntent(alarmID: context.attributes.alarmID)) {
                        Text("Matiin Alarm")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                    .padding(.vertical, 6)
                    .background(Color.red.opacity(0.25))
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
                         .padding(.top, 11) // Padding Atas
                        .padding(.bottom, 4)

                    Text("Santai aja, tinggal istirahat")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    HStack(spacing: 4) {
                        Text("menuju")
                            .foregroundColor(.gray)
                        Text(context.attributes.destinationStationName)
                            .foregroundColor(.cyan)
                            .fontWeight(.bold)
                    }
                    .font(.subheadline)
                }.padding(.bottom, -9)

                // Custom Progress Bar Component
                TrainProgressBar(progress: context.state.progress, tintColor: .cyan)
                    .padding(.top, 8)
                    .padding(.bottom, -8)
                

                // Cancel Button
                HStack {
                    Spacer()
                    Button(intent: CancelAlarmIntent(alarmID: context.attributes.alarmID)) {
                        Text("Matiin Alarm")
                            .font(.subheadline)
//                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 25)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.plain)
                    .background( // Button Color
                        Capsule()
                            .fill(Color.white.opacity(0.15))
                    )
                    .background( // Blur & Dark Layer
                            Capsule()
                                .fill(.ultraThinMaterial)
                                .opacity(0.6)
                        )
                    .overlay( // Stroke
                        Capsule()
                            .stroke(Color.white.opacity(0.4), lineWidth: 0.5)
                    )
                    Spacer()
                }
                .padding(.bottom, 1)
            }
            .padding()
            .padding(.bottom, 11)
            .activityBackgroundTint(Color.black.opacity(0.95))
                        .activitySystemActionForegroundColor(Color.white)
        }
    }
}

struct CancelButtonView: View {
    let alarmID: String
    
    var body: some View {
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

#Preview("Lock Screen", as: .content, using: BanguninAlarmAttributes(alarmID: "123", destinationStationName: "Manggarai")) {
    BanguninWidgetLiveActivity()
} contentStates: {
    BanguninAlarmAttributes.ContentState(progress: 0.5)
}
