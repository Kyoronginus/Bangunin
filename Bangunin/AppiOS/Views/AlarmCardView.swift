//
//  AlarmCardView.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 02/07/26.
//

import SwiftUI

struct AlarmCardView: View {
    
    @Binding var alarm: Alarm
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(alarm.label)
                    .foregroundStyle(.gray)
                HStack {
                    Text(alarm.departureStation)
                        .bold()
                        .font(.title)
//                        .lineLimit(1)
//                        .minimumScaleFactor(0.6)
                    Image(systemName: "arrow.right")
                    Text(alarm.destinationStation)
                        .bold()
                        .font(.title)
//                        .lineLimit(1)
//                        .minimumScaleFactor(0.6)
                }
                Text(alarm.repeatStatus)
            }
            Spacer()
            Toggle("", isOn: $alarm.isActive)
                .tint(.green)
                .labelsHidden()
                .offset(y:20)
        }
        .padding()
    }
}
