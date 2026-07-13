//
//  AlarmCardView.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 02/07/26.
//

import SwiftUI

struct AlarmCardView: View {

    @Environment(\.editMode) private var editMode
    var viewModel: AlarmCardViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(spacing: 4) {
                Image(systemName: "alarm")
                Text(viewModel.alarm.wakeUpTime.rawValue)
            }
            .font(.subheadline)
            .foregroundStyle(.gray)
            
            // Body
            if !viewModel.isOneTime {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Berangkat dari")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        Text(viewModel.alarm.departureStation)
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.black)
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.gray.opacity(0.3))
                        .padding(.horizontal, 8)
                    
                    VStack(alignment: .trailing) {
                        Text("Turun di")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        Text(viewModel.alarm.destinationStation)
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.black)
                    }
                }
                
                if viewModel.isWaiting {
                    Text("Standby, nunggu kamu naik dari \(viewModel.alarm.departureStation)")
                        .font(.caption)
                        .italic()
                        .foregroundStyle(.gray)
                }
            } else {
                VStack(alignment: .leading) {
                    Text("Turun di")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Text(viewModel.alarm.destinationStation)
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.black)
                }
            }
            
            // Footer
            HStack {
                if !viewModel.isOneTime {
                    HStack(spacing: 6) {
                        Image(systemName: "calendar")
                        Text(viewModel.repeatStatus)
                    }
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Capsule().stroke(Color.blue.opacity(0.3), lineWidth: 1))
                    .foregroundStyle(.blue)
                }
                
                Spacer()
                
                if editMode?.wrappedValue.isEditing == true {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .opacity(0.5)
                } else {
                    Toggle(
                        "",
                        isOn: Binding(
                            get: { viewModel.alarm.isActive },
                            set: { newValue in
                                viewModel.toggleAlarm(isActive: newValue)
                            }
                        )
                    )
                    .tint(.blue)
                    .labelsHidden()
                }
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
