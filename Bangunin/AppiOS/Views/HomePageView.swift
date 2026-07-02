//
//  HomePageView.swift
//  Bangunin
//
//  Created by Kezia Karen Amelia on 02/07/26.
//

import SwiftUI

struct HomePageView: View {
    var body: some View {
        ZStack {
            VStack {
                // top bar
                HStack {
                    Button {
                    
                    } label: {
                        Text("Edit")
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(.gray.opacity(0.2))
                            .clipShape(Capsule())
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                            .frame(width: 40, height: 40)
                            .background(.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                }
                .padding(.horizontal)
                
                // title
                HStack {
                    Text("Alarms")
                        .font(.system(size: 40, weight: .bold))
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Spacer()
                
                // tambahin if else disini (kalau tidak ada data alarm masuk ke empty state)
                
                // empty state
                VStack(spacing: 8) {
                    Text("No alarms yet")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Text("Click the + button to add your alarm")
                        .font(.body)
                        .fontWeight(.regular)
                }
                
                Spacer()
            }
            .padding(.all)
        }
    }
}

#Preview {
    HomePageView()
}
