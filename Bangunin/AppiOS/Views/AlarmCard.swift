//
//  Untitled.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 02/07/26.
//

import SwiftUI

struct AlarmCardView: View {
    
    var alarmLabel: String = "Work"
    var departureStation: String = "Cisauk"
    var destinationStation: String = "Palmerah"
    
    @State var isOn: Bool = false
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(alarmLabel)
                    .foregroundStyle(.gray)
                HStack {
                    Text(departureStation)
                        .bold()
                        .font(.title)
//                        .lineLimit(1)
//                        .minimumScaleFactor(0.6)
                    Image(systemName: "arrow.right")
                    Text(destinationStation)
                        .bold()
                        .font(.title)
//                        .lineLimit(1)
//                        .minimumScaleFactor(0.6)
                }
                Text("Repeat every weekday")
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .tint(.green)
                .labelsHidden()
                .offset(y:20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AlarmCardView(
        alarmLabel: "Work",
        departureStation: "Kebayoran",
        destinationStation: "Rangkasbitung",
        isOn: true
    )
    Divider()
    AlarmCardView(
        alarmLabel: "Work",
        departureStation: "Juranmangu",
        destinationStation: "Cisauk",
        isOn: true
    )
}
