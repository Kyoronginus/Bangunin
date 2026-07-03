//
//  RepeatSelectionView.swift
//  Bangunin
//

import SwiftUI

struct RepeatSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedRepeatOptions: Set<RepeatOption>

    var body: some View {
        VStack(spacing: 16) {
            // custom top bar matching AddAlarmView
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(Color(UIColor.systemBackground))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                }

                Spacer()

                Text("Repeat")
                    .font(.headline)
                    .bold()

                Spacer()
                
                // Invisible view for symmetry
                Color.clear
                    .frame(width: 44, height: 44)
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            ScrollView {
                VStack(spacing: 0) {
                    let repeatOptions = RepeatOption.allCases
                    ForEach(repeatOptions.indices, id: \.self) { index in
                        let option = repeatOptions[index]
                        Button {
                            if selectedRepeatOptions.contains(option) {
                                selectedRepeatOptions.remove(option)
                            } else {
                                selectedRepeatOptions.insert(option)
                            }
                        } label: {
                            HStack {
                                Text(option.rawValue)
                                    .foregroundColor(.primary)
                                Spacer()
                                if selectedRepeatOptions.contains(option) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.orange)
                                        .bold()
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                        }
                        
                        if index < repeatOptions.count - 1 {
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                }
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
            }
        }
        .navigationBarHidden(true)
    }
}
