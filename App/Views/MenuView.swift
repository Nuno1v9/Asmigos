import SwiftUI

struct MenuView: View {
    @ObservedObject var vm: GameViewModel

    var body: some View {
        ZStack {
            AsmigosBackground()
            VStack(spacing: 20) {
                Spacer()
                Text("Asmigos")
                    .font(.system(size: 44, weight: .heavy))
                    .foregroundStyle(.white)

                Text("Entra numa sala ou cria a tua")
                    .foregroundStyle(AsmigosTheme.lightText.opacity(0.85))

                VStack(spacing: 12) {
                    PrimaryButton(title: "Entrar em sala") {
                        vm.phase = .joinLobby
                    }
                    PrimaryButton(title: "Criar sala") {
                        vm.phase = .createLobby
                    }
                }
                .padding(.top, 12)

                Spacer()
            }
            .padding(24)
        }
    }
}
