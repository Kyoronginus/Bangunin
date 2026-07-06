//
//  ContentView.swift
//  BanguninWatch Watch App
//

import SwiftUI

struct ContentView: View {
    @StateObject private var watchConnectivity = WatchConnectivityManager.shared
    
    var body: some View {
        VStack(spacing: 12) {
            if watchConnectivity.isAlarmActive, let destination = watchConnectivity.activeDestination {
                // ACTIVE ALARM UI
                VStack(alignment: .leading, spacing: 4) {
                    Text("Alarm Active")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 4) {
                        Text("to")
                            .foregroundColor(.gray)
                        Text(destination)
                            .foregroundColor(.cyan)
                            .fontWeight(.bold)
                    }
                    .font(.footnote)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                // Custom Progress Bar (Mockup)
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 6)
                        
                        Capsule()
                            .fill(Color.cyan)
                            .frame(width: geometry.size.width * 0.5, height: 6) // Mock 50%
                        
                        Image(systemName: "tram.fill")
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.black)
                            .clipShape(Circle())
                            .offset(x: (geometry.size.width * 0.5) - 12)
                        
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .background(Color.white)
                            .clipShape(Circle())
                            .offset(x: geometry.size.width - 12)
                    }
                }
                .frame(height: 24)
                
                Spacer()
                
                Button(action: {
                    watchConnectivity.sendCancelMessage()
                    watchConnectivity.isAlarmActive = false
                }) {
                    Text("Cancel Alarm")
                        .fontWeight(.semibold)
                }
                .buttonStyle(.borderedProminent)
                .tint(.gray.opacity(0.4))
                .clipShape(Capsule())
                
            } else {
                // NO ALARM UI
                VStack {
                    Image(systemName: "tram.fill")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("No Active Alarm")
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                    Text("Set an alarm from your iPhone.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
