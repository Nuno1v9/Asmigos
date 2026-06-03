import SwiftUI

struct BonusMinigameView: View {
    @EnvironmentObject var vm: GameViewModel

    @State private var showTapWar = false

    private var isDuel: Bool { vm.bonusContext == .correctVotersDuel }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                Text("DESEMPATE!")
                    .font(.system(size: 32, weight: .black))
                    .foregroundColor(.white)
                    .italic()

                Text(introMessage)
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                if isDuel, vm.bonusPlayers.count == 2 {
                    HStack(spacing: 24) {
                        duelPlayerLabel(vm.bonusPlayers[0], slot: 1)
                        Text("VS")
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(.white.opacity(0.4))
                        duelPlayerLabel(vm.bonusPlayers[1], slot: 2)
                    }
                }

                VStack(spacing: 8) {
                    Text("O JOGO É:")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white.opacity(0.5))

                    Text(SessionMinigame.tapWar.rawValue)
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundColor(Color(red: 0.8, green: 0.1, blue: 0.1))
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(16)

                AsmigosButton(title: "JOGAR TAP WAR", color: Color(red: 0.8, green: 0.1, blue: 0.1)) {
                    showTapWar = true
                }
                .padding(.horizontal, 40)

                Spacer()

                if vm.bonusPlayers.count == 2 {
                    playerPickSection
                }
            }
        }
        .fullScreenCover(isPresented: $showTapWar) {
            tapWarSheet
        }
        .onAppear {
            vm.selectedBonusMinigame = .tapWar
        }
    }

    @ViewBuilder
    private var tapWarSheet: some View {
        if vm.bonusPlayers.count >= 2 {
            let p1 = vm.bonusPlayers[0]
            let p2 = vm.bonusPlayers[1]
            TapWarView(
                player1Name: p1.name,
                player2Name: p2.name,
                onComplete: isDuel ? duelCompleteHandler : nil
            )
        } else {
            TapWarView()
        }
    }

    @ViewBuilder
    private var playerPickSection: some View {
        VStack(spacing: 16) {
            Text(isDuel ? "QUEM GANHOU?" : "QUEM PERDEU?")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)

            HStack(spacing: 16) {
                ForEach(vm.bonusPlayers) { player in
                    Button {
                        if isDuel {
                            vm.submitCorrectVotersDuelWinner(winnerID: player.id)
                        } else {
                            vm.submitBonusResult(loserID: player.id)
                        }
                    } label: {
                        VStack(spacing: 8) {
                            Image("char_\(player.imageName)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                            Text(player.name.uppercased())
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background((isDuel ? Color.green : Color.red).opacity(0.2))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isDuel ? Color.green : Color.red, lineWidth: 2)
                        )
                    }
                }
            }
        }
        .padding(.bottom, 40)
    }

    private var duelCompleteHandler: (Int) -> Void {
        { slot in
            guard vm.bonusPlayers.count >= 2 else { return }
            switch slot {
            case 1:
                vm.submitCorrectVotersDuelWinner(winnerID: vm.bonusPlayers[0].id)
            case 2:
                vm.submitCorrectVotersDuelWinner(winnerID: vm.bonusPlayers[1].id)
            default:
                break
            }
        }
    }

    private var introMessage: String {
        if isDuel {
            return "Os dois apanharam o impostor!\nTap War decide quem marca o ponto."
        }
        return "Ninguém apanhou o impostor.\nTap War decide quem perde uma vida."
    }

    private func duelPlayerLabel(_ player: Player, slot: Int) -> some View {
        VStack(spacing: 6) {
            Text("J\(slot)")
                .font(.system(size: 11, weight: .heavy))
                .foregroundColor(.white.opacity(0.4))
            Text(player.name)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
        }
    }
}
