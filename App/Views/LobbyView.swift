import SwiftUI

struct LobbyView: View {
    @ObservedObject var vm: GameViewModel

    var body: some View {
        ZStack {
            AsmigosBackground()
            VStack(spacing: 18) {
                Text("Ronda \(vm.roundNumber)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.8))

                Text("Código: \(vm.lobbyCode)")
                    .font(.headline)
                    .foregroundStyle(.white)

                Text("Host: \(vm.hostName)")
                    .foregroundStyle(.white.opacity(0.8))

                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(vm.players) { player in
                            HStack {
                                Text(player.name)
                                    .foregroundStyle(.white)
                                Spacer()
                                Text("\(player.score) pts")
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                            .padding(12)
                            .background(AsmigosTheme.panel)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }

                HStack(spacing: 10) {
                    PrimaryButton(title: "Adicionar Bot") {
                        vm.addBot()
                    }
                    PrimaryButton(title: "Começar") {
                        vm.startRound()
                    }
                }

                Button("Sair da sala") {
                    vm.backToMenu()
                }
                .foregroundStyle(.white.opacity(0.8))
            }
            .padding(24)
        }
    }
}
