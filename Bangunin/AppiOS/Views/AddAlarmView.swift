//
//  AddAlarmView.swift
//  Bangunin
//
//  Created by Kezia Karen Amelia on 02/07/26.
//

import SwiftUI

struct AddAlarmView: View {

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            // top bar
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 40, height: 40)
                        .background(.gray.opacity(0.2))
                        .clipShape(Circle())

                }

                Spacer()

                Text("New Alarm")
                    .font(.title2.bold())

                Spacer()

                Button {
                    // untuk save alarmnya
                } label: {
                    Image(systemName: "checkmark")
                        .frame(width: 40, height: 40)
                        .background(.gray.opacity(0.2))
                        .clipShape(Circle())

                }

            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            Spacer()
            
            // untuk alarm details
            VStack {
                
                // isi detail alarm
                Text("Isi alarm details")
                
            }

            Spacer()
        }
    }
}

#Preview {
    AddAlarmView()
}
