import Foundation
import AppIntents

// This intent will be triggered when the user taps "Cancel Alarm" in the Live Activity.
// Since this intent runs in the app's process, we can populate a static closure in the app 
// to execute the cancellation logic, keeping the Widget Extension agnostic of our app managers.
@available(iOS 16.1, *)
public struct CancelAlarmIntent: LiveActivityIntent {
    public static var title: LocalizedStringResource = "Cancel Alarm"
    
    // The main app will assign this closure when it starts up.
    public static var cancelAction: (() -> Void)?
    
    public init() {}
    
    public func perform() async throws -> some IntentResult {
        // Execute the cancellation action provided by the main app process
        Self.cancelAction?()
        return .result()
    }
}

