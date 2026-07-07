import SwiftUI

struct TrainProgressBar: View {
    var progress: Double
    var tintColor: Color = .yellow
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                Capsule()
                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    .frame(height: 6)
                
                Capsule()
                    .fill(tintColor)
                    .frame(width: max(0, geometry.size.width * progress), height: 6)
                
                Image("destination")
                    .resizable()
                    .frame(width: 20)
                    .position(x: geometry.size.width - 5, y: -5)
                
                Image(systemName: "train.side.front.car")
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
                    .padding(4)
                    .clipShape(Capsule())
                    .position(x: max(16, geometry.size.width * progress), y: 8)
            }
        }
        .frame(height: 24)
    }
}

#Preview {
    VStack(spacing: 40) {
        TrainProgressBar(progress: 0.0)
        TrainProgressBar(progress: 0.5)
        TrainProgressBar(progress: 1.0)
    }
    .padding()
    .background(Color.blue)
}
