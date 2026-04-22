import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            AsmigosBackground()
            VStack(spacing: 16) {
                Text("Asmigos")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundStyle(.white)
                Text("by Mosguero")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
    }
}
