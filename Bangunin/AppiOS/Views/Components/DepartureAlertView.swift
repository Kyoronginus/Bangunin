//
//  DepartureAlertView.swift
//  Bangunin
//
//  Created by Tohru Djunaedi Sato on 13/07/26.
//

import SwiftUI

struct DepartureAlertView: View {
    var onConfirm: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // 1. Text Labels
            VStack(spacing: 8) {
                Text("Cek lagi, udah bener belum?")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text("Begitu kamu naik dari stasiun ini, alarm otomatis aktif dan bakal bunyi pas kamu deket stasiun tujuan")
                    .font(.body)
                    .foregroundColor(.black.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.top, 10)
            

            Button {
                onConfirm()
            } label: {
                Text("Oke, Paham")
                    .font(.body)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
        }
        .padding(24)
        .frame(maxWidth: 320)
        .background(Color(red: 0.9, green: 0.9, blue: 0.9))
        .cornerRadius(28)
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
    }
}


#Preview{
    DepartureAlertView(onConfirm:  {})
}
