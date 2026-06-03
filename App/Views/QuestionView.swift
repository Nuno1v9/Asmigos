import SwiftUI

struct QuestionView: View {
    @EnvironmentObject var vm: GameViewModel
    @State private var revealed = false
    @State private var currentIndex = 0

    private var currentPlayer: Player { vm.alivePlayers[currentIndex] }
    private var isImpostor: Bool { currentPlayer.isImpostor }

    private var question: String {
        guard let q = vm.currentQuestion else { return "" }
        return isImpostor ? q.fake : q.real
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    AsmigosLogo(size: 26)
                    Spacer()
                    Text("Jogador \(currentIndex + 1)/\(vm.alivePlayers.count)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.4))
                }
                .padding(.horizontal, 28)
                .padding(.top, 56)

                Spacer()

                VStack(spacing: 32) {
                    VStack(spacing: 8) {
                        Text("É A VEZ DE")
                            .font(.system(size: 11, weight: .heavy))
                            .foregroundColor(.white.opacity(0.35))
                            .tracking(4)
                        VStack(spacing: 16) {
                            Text(currentPlayer.name.uppercased())
                                .font(.system(size: 32, weight: .black))
                                .italic()
                                .foregroundColor(.white)
                            Image("char_\(currentPlayer.imageName)")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 200, maxHeight: 200)
                        }
                    }

                    if revealed {
                        VStack(spacing: 24) {
                            Text(question)
                                .font(.system(size: 36, weight: .black))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                                .padding(.vertical, 24)
                                .background(Color(white: 0.1))
                                .cornerRadius(14)
                                .padding(.horizontal, 28)

                            AsmigosButton(title: "RESPOSTA DADA →", color: Color(red: 0.6, green: 0.05, blue: 0.05)) {
                                nextPlayer()
                            }
                            .padding(.horizontal, 28)
                        }
                        .transition(.opacity)
                    } else {
                        AsmigosButton(title: "VER PALAVRA", color: Color(white: 0.18)) {
                            withAnimation { revealed = true }
                        }
                        .padding(.horizontal, 28)
                        Text("Passa o telemóvel para \(currentPlayer.name)")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.35))
                    }
                }

                Spacer()
            }
        }
    }

    private func nextPlayer() {
        if currentIndex < vm.alivePlayers.count - 1 {
            currentIndex += 1
            revealed = false
        } else {
            vm.advanceToVoting()
        }
    }
}
