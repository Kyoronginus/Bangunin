import SwiftUI
import AppIntents

struct ActiveAlarmCardView: View {
    let viewModel: ActiveAlarmCardViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // White Header
            HStack {
                Text("Alarm Aktif")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.blue)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "alarm")
                    Text(viewModel.alarm.wakeUpTime.rawValue)
                }
                .font(.caption)
                .foregroundStyle(.gray)
            }
            .padding()
            .background(Color.white)
            
            // Blue Body
            VStack(alignment: .leading, spacing: 16) {
                if !viewModel.alarm.repeatOptions.isEmpty {
                    // Departure and Destination with Slider
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Berangkat dari")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.8))
                            Text(viewModel.alarm.departureStation)
                                .font(.title3)
                                .bold()
                                .foregroundStyle(.white)
                        }
                        
                        // Progress visualization
                        HStack(spacing: 0) {
                            Circle().frame(width: 6, height: 6).foregroundStyle(.white)
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .frame(height: 2)
                                        .foregroundStyle(.white.opacity(0.3))
                                    Rectangle()
                                        .frame(width: geometry.size.width * CGFloat(viewModel.progress), height: 2)
                                        .foregroundStyle(.white)
                                }
                            }
                            .frame(height: 2)
                            Circle().frame(width: 6, height: 6).foregroundStyle(.white)
                        }
                        .padding(.horizontal, 8)
                        
                        VStack(alignment: .trailing) {
                            Text("Turun di")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.8))
                            Text(viewModel.alarm.destinationStation)
                                .font(.title3)
                                .bold()
                                .foregroundStyle(.white)
                        }
                    }
                } else {
                    // Only Destination
                    VStack(alignment: .leading) {
                        Text("Turun di")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                        Text(viewModel.alarm.destinationStation)
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.white)
                    }
                }
                
                Divider()
                    .background(Color.white.opacity(0.5))
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Kamu akan sampai dalam")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                        Text(viewModel.etaString.isEmpty ? "Menghitung..." : viewModel.etaString)
                            .font(.headline)
                            .bold()
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                    
                    Button(intent: CancelAlarmIntent(alarmID: viewModel.alarm.id.uuidString)) {
                        Text("Matiin Alarm")
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .foregroundStyle(.black)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            .background(Color.blue)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
    
}

#Preview {
    ActiveAlarmCardView(viewModel: ActiveAlarmCardViewModel(alarm: Alarm(
        label: "Kerja",
        departureStation: "Sudirman",
        destinationStation: "Palmerah",
        wakeUpTime: .fiveMin,
        repeatOptions: [],
        isVibrationOn: true,
        isSoundOn: true
    )))
}
