import Foundation
import ActivityKit

public struct AlarmAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic state of the activity goes here.
        // For example, time remaining or progress if we were tracking live progress.
        var progress: Double
    }

    // Fixed non-changing properties about your activity go here!
    var destinationStationName: String
}
