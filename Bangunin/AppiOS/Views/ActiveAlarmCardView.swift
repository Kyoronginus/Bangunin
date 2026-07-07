import SwiftUI
import AppIntents

struct ActiveAlarmCardView: View {
    @Bindable var viewModel: ActiveAlarmCardViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // 1. Destination Info
            VStack(alignment: .leading, spacing: 4) {
                Text("Bangunin saya di")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
                
                Text(viewModel.alarm.destinationStation)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            
            // 2. Estimation Info
            VStack(alignment: .leading, spacing: 4) {
                Text("Estimasi alarm berbunyi dalam")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
                
                Text(String(format: "%d menit", viewModel.estimatedMinutesRemaining))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            
            // 3. Progress Bar
            TrainProgressBar(progress: viewModel.progress)
                .padding(.top, 10)
                .padding(.bottom, 10)
            
            // 4. Cancel Button
            HStack {
                Spacer()
                Button(intent: CancelAlarmIntent()) {
                    Text("Batalkan Alarm")
                        .font(.body)
                        .foregroundStyle(.black)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.plain)
                .background(Color.white.opacity(0.6))
                .clipShape(Capsule())
                Spacer()
            }
        }
        .padding(24)
        .background(Color(red: 0.1, green: 0.5, blue: 0.95))
        .clipShape(RoundedRectangle(cornerRadius: 24))
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
