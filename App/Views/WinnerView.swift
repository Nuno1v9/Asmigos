import SwiftUI

struct WinnerView: View {
    @ObservedObject var vm: GameViewModel

    var body: some View {
        ZStack {
            AsmigosBackground()
            VStack(spacing: 18) {
                Text(vm.gameOver ? "Vencedor do jogo!" : "Vencedor da ronda!")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white.opacity(0.85))

                Text(vm.winnerName.uppercased())
                    .font(.system(size: 40, weight: .black))
                    .foregroundStyle(AsmigosTheme.accent)

                Text(vm.winnersText)
                    .foregroundStyle(.white.opacity(0.86))
                    .multilineTextAlignment(.center)

                VStack(spacing: 10) {
                    if !vm.gameOver {
                        PrimaryButton(title: "Nova ronda") {
                            vm.nextRound()
                        }
                    }
                    PrimaryButton(title: "Menu principal") {
                        vm.backToMenu()
                    }
                }
            }
            .padding(24)
        }
    }
}
