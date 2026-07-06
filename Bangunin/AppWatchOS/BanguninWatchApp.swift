//
//  BanguninWatchApp.swift
//  BanguninWatch Watch App
//
//  Created by Tohru Djunaedi Sato on 06/07/26.
//

import SwiftUI

@main
struct BanguninWatch_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    print("Watch app opened via URL: \(url)")
                }
        }
    }
}
