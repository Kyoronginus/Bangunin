//
//  BanguninApp.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 02/07/26.
//

import SwiftUI
import SwiftData

@main
struct IOSApp: App {
    var body: some Scene {
        WindowGroup {
            HomePageView()
        }.modelContainer(for: Alarm.self)
    }
}
