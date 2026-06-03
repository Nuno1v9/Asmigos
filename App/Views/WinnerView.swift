import SwiftUI

struct WinnerView: View {
    @EnvironmentObject var vm: GameViewModel

    private var champions: [Player] { vm.winners() }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 28) {
                Spacer()
                Text("🏆")
                    .font(.system(size: 80))
                AsmigosLogo(size: 42)

                if champions.count == 1, let winner = champions.first {
                    Text("TEMOS UM VENCEDOR!")
                        .font(.system(size: 13, weight: .heavy))
                        .foregroundColor(.white.opacity(0.4))
                        .tracking(3)
                    VStack(spacing: 16) {
                        Text(winner.name.uppercased())
                            .font(.system(size: 42, weight: .black))
                            .italic()
                            .foregroundColor(Color(red: 0.8, green: 0.1, blue: 0.1))
                        Image("char_\(winner.imageName)")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200, maxHeight: 200)
                    }
                    Text("\(winner.score) pontos")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.5))
                } else {
                    Text("EMPATE!")
                        .font(.system(size: 13, weight: .heavy))
                        .foregroundColor(.white.opacity(0.4))
                        .tracking(3)
                    ForEach(champions) { player in
                        HStack(spacing: 12) {
                            Image("char_\(player.imageName)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            Text("\(player.name) — \(player.score) pts")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }

                Spacer()

                AsmigosButton(title: "JOGAR NOVAMENTE", color: Color(white: 0.18)) {
                    vm.startGame()
                }
                .padding(.horizontal, 28)

                AsmigosButton(title: "MENU PRINCIPAL", color: Color(red: 0.6, green: 0.05, blue: 0.05)) {
                    vm.resetToMenu()
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 50)
            }
        }
    }
}
