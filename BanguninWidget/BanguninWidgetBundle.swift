//
//  BanguninWidgetBundle.swift
//  BanguninWidget
//
//  Created by Tohru Djunaedi Sato on 04/07/26.
//

import WidgetKit
import SwiftUI

@main
struct BanguninWidgetBundle: WidgetBundle {
    var body: some Widget {
        BanguninWidget()
        BanguninWidgetControl()
        BanguninWidgetLiveActivity()
        AlarmKitLiveActivity()
    }
}
