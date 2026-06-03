import SwiftUI

struct SplashView: View {
    @EnvironmentObject var vm: GameViewModel

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 16) {
                Text("💀🔥")
                    .font(.system(size: 64))
                AsmigosLogo(size: 52)
                Text("Descubra o impostor dentre os seus asmigos.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
        .task {
            try? await Task.sleep(for: .milliseconds(800))
            vm.screen = .menu
        }
    }
}
