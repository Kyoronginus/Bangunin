//
//  WatchConnectivityManager.swift
//  Bangunin
//

import Foundation
import WatchConnectivity
import Combine

class WatchConnectivityManager: NSObject, ObservableObject {
    static let shared = WatchConnectivityManager()
    
    @Published var activeDestination: String? = nil
    @Published var isAlarmActive: Bool = false
    
    private override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    // Dipanggil dari iPhone ke Watch (atau sebaliknya)
    func syncAlarmState(destination: String?, isActive: Bool) {
        self.activeDestination = destination
        self.isAlarmActive = isActive
        
        guard WCSession.isSupported() else { return }
        
        do {
            let context: [String: Any] = [
                "destination": destination ?? "",
                "isActive": isActive
            ]
            try WCSession.default.updateApplicationContext(context)
            print("WCSession: Application context synced successfully.")
        } catch {
            print("WCSession: Failed to sync application context: \(error.localizedDescription)")
        }
    }
    
    // Dipanggil dari Watch ke iPhone (untuk membatalkan alarm)
    func sendCancelMessage() {
        guard WCSession.isSupported(), WCSession.default.activationState == .activated else { return }
        WCSession.default.sendMessage(["action": "cancelAlarm"], replyHandler: nil, errorHandler: { error in
            print("WCSession: Failed to send message: \(error.localizedDescription)")
        })
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
            
            // Baca data terakhir yang diterima saat app tidak aktif
            if !session.receivedApplicationContext.isEmpty {
                self.session(session, didReceiveApplicationContext: session.receivedApplicationContext)
            }
        }
    }
    
    // Menerima update status (berfungsi di iPhone & Watch)
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async {
            if let dest = applicationContext["destination"] as? String, !dest.isEmpty {
                self.activeDestination = dest
            } else {
                self.activeDestination = nil
            }
            
            if let active = applicationContext["isActive"] as? Bool {
                self.isAlarmActive = active
            }
        }
    }
    
    // Menerima pesan instan (Contoh: Watch menyuruh iPhone cancel alarm)
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let action = message["action"] as? String, action == "cancelAlarm" {
                print("WCSession: Received cancel alarm command from Watch")
                
                #if os(iOS)
                // Hanya iPhone yang punya LocationManager
                LocationManager.shared.stopMonitoringRoute()
                #endif
            }
        }
    }

#if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) { }
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
#endif
}
