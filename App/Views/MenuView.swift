import SwiftUI

struct MenuView: View {
    @EnvironmentObject var vm: GameViewModel

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    HStack(spacing: 6) {
                        Text("💀🔥")
                            .font(.system(size: 28))
                        AsmigosLogo(size: 22)
                    }
                    Spacer()
                }
                .padding(.horizontal, 28)
                .padding(.top, 56)

                Spacer()

                VStack(spacing: 12) {
                    AsmigosLogo(size: 58)
                    Text("Descubra o impostor dentre os seus asmigos.")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.65))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                Spacer()

                VStack(spacing: 18) {
                    AsmigosButton(title: "JOGAR", color: Color(red: 0.6, green: 0.05, blue: 0.05)) {
                        vm.screen = .lobby
                    }
                    AsmigosButton(title: "MINIJOGOS 1v1", color: Color(white: 0.18)) {
                        vm.screen = .minigamesMenu
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 60)
            }
        }
    }
}
