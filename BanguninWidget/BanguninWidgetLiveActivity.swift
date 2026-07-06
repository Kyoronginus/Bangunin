//
//  BanguninWidgetLiveActivity.swift
//  BanguninWidget
//

import ActivityKit
import WidgetKit
import SwiftUI
import AppIntents

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
                        CancelButtonView()
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
            // Apple Watch Smart Stack UI
            VStack(alignment: .leading, spacing: 1) {
                Text("Alarm Active")
                    .font(.caption)
                    .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    Text("to")
                        .foregroundColor(.gray)
                    Text(context.attributes.destinationStationName)
                        .foregroundColor(.cyan)
                        .fontWeight(.bold)
                }
                .font(.footnote)
                
//                Spacer()
//                
//                if #available(iOS 17.0, *) {
//                    Button(intent: CancelAlarmIntent()) {
//                        Text("Cancel")
//                            .font(.caption2)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                    }
//                    .buttonStyle(.plain)
//                    .padding(.vertical, 4)
//                    .background(Color.white.opacity(0.15))
//                    .clipShape(Capsule())
//                }
            }
            .padding()
            .widgetURL(URL(string: "bangunin://open"))
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
                        // Background track
                        Capsule()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 6)
                        
                        // Active track
                        Capsule()
                            .fill(Color.cyan)
                            .frame(width: geometry.size.width * context.state.progress, height: 6)
                        
                        // Train Icon (Mockup)
                        Image(systemName: "tram.fill")
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.black)
                            .clipShape(Circle())
                            .offset(x: (geometry.size.width * context.state.progress) - 12)
                        
                        // Destination Pin
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
                    if #available(iOS 17.0, *) {
                        Button(intent: CancelAlarmIntent()) {
                            Text("Cancel Alarm")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 8)
                        }
                        .buttonStyle(.plain)
                        .background(Color.white.opacity(0.15))
                        .clipShape(Capsule())
                    } else {
                        // Fallback for earlier versions if needed
                        Text("Open app to cancel")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
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
    var body: some View {
        if #available(iOS 17.0, *) {
            Button(intent: CancelAlarmIntent()) {
                Text("Cancel")
                    .font(.subheadline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
            }
            .buttonStyle(.plain)
            .background(Color.white.opacity(0.2))
            .clipShape(Capsule())
        } else {
            Text("Cancel from app")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

import AlarmKit

struct AlarmKitLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AlarmKit.AlarmAttributes<EmptyMetadata>.self) { context in
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
