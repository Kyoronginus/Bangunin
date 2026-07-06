import Foundation
import ActivityKit
import AlarmKit

public struct BanguninAlarmAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic state of the activity goes here.
        // For example, time remaining or progress if we were tracking live progress.
        var progress: Double
    }

    // Fixed non-changing properties about your activity go here!
    var destinationStationName: String
}

public struct EmptyMetadata: AlarmMetadata, Codable, Hashable {
    public init() {}
}
