import SwiftUI

struct ProgressBar: View {
    var value: Double
    var maxValue: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .frame(height: 20)
                    .foregroundColor(Color.gray.opacity(0.3))
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: CGFloat(value / maxValue) * geometry.size.width, height: 20)
                    .foregroundColor(.accentColor)
                    .animation(.easeOut, value: value)
            }
        }
        .frame(height: 20)
    }
}

#Preview {
    ProgressBar(value: 500, maxValue: 1000)
        .frame(height: 20)
        .padding()
}
