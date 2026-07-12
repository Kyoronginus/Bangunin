//
//  AlarmCardView.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 02/07/26.
//

import SwiftUI

struct AlarmCardView: View {

//    @Bindable var alarm: Alarm
    var viewModel: AlarmCardViewModel

    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(viewModel.alarm.label)
                    .foregroundStyle(.gray)
                HStack {
                    Text(viewModel.alarm.departureStation)
                        .bold()
                        .font(.title)
                    Image(systemName: "arrow.right")
                    Text(viewModel.alarm.destinationStation)
                        .bold()
                        .font(.title)
                }
                Text(viewModel.repeatStatus)
            }
            Spacer()
            Toggle("", isOn: Binding(
                get: { viewModel.alarm.isActive },
                set: { newValue in viewModel.toggleAlarm(isActive: newValue) }
            ))
            .tint(.green)
            .labelsHidden()
            .offset(y: 20)
        }
        .padding()
    }
    
}
