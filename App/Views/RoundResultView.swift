import SwiftUI

struct RoundResultView: View {
    @EnvironmentObject var vm: GameViewModel

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 28) {
                Spacer()
                AsmigosLogo(size: 36)

                Text("RESULTADO DA RONDA")
                    .font(.system(size: 11, weight: .heavy))
                    .foregroundColor(.white.opacity(0.35))
                    .tracking(3)

                if vm.roundWinners.isEmpty {
                    VStack(spacing: 12) {
                        Text("🤷")
                            .font(.system(size: 56))
                        Text("Ninguém marcou ponto!")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        if !vm.correctVoters.isEmpty {
                            Text("O impostor fugiu para \(vm.impostorDirection.label)!")
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.5))
                        } else if let impostor = vm.impostor {
                            HStack(spacing: 8) {
                                Image("char_\(impostor.imageName)")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                Text("O impostor (\(impostor.name)) escapou desta vez!")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                        }
                    }
                } else {
                    VStack(spacing: 12) {
                        Text("🎉")
                            .font(.system(size: 56))
                        ForEach(vm.roundWinners) { winner in
                            HStack(spacing: 8) {
                                Image("char_\(winner.imageName)")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                Text("\(winner.name) marcou 1 ponto!")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color(red: 0.8, green: 0.1, blue: 0.1))
                            }
                        }
                    }
                }

                VStack(spacing: 8) {
                    Text("PONTUAÇÃO")
                        .font(.system(size: 11, weight: .heavy))
                        .foregroundColor(.white.opacity(0.35))
                        .tracking(3)
                    ForEach(vm.players.sorted(by: { $0.score > $1.score })) { player in
                        HStack {
                            Image("char_\(player.imageName)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .clipShape(Circle())
                            Text(player.name)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(player.score) pts")
                                .font(.system(size: 16, weight: .black))
                                .foregroundColor(player.score > 0 ? Color(red: 0.8, green: 0.1, blue: 0.1) : .white.opacity(0.4))
                        }
                        .padding(.horizontal, 32)
                    }
                }

                Spacer()

                AsmigosButton(title: "PRÓXIMA RONDA →", color: Color(red: 0.6, green: 0.05, blue: 0.05)) {
                    vm.proceedFromRoundResult()
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 50)
            }
        }
    }
}
