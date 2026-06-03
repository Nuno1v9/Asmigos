import SwiftUI

struct VoteResultView: View {
    @EnvironmentObject var vm: GameViewModel

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 32) {
                Spacer()
                AsmigosLogo(size: 36)

                if let elim = vm.recentlyEliminatedPlayer {
                    VStack(spacing: 16) {
                        Text(elim.isImpostor ? "🎯" : "💀")
                            .font(.system(size: 72))
                        Text("\(elim.name.uppercased()) FOI ELIMINADO!")
                            .font(.system(size: 24, weight: .black))
                            .italic()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(elim.isImpostor ? "Era o impostor!" : "NÃO era o impostor...")
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.6))
                        
                        if elim.isImpostor {
                            Text("Passam ao minijogo: " + vm.correctVoters.map { $0.name }.joined(separator: ", "))
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color(red: 0.8, green: 0.1, blue: 0.1))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        } else {
                            let aliveCivilians = vm.alivePlayers.filter { !$0.isImpostor }.count
                            if aliveCivilians <= 1 {
                                Text("O Impostor Ganhou a Ronda!")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.red)
                            } else {
                                Text("A ronda continua com os sobreviventes...")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    }
                } else {
                    VStack(spacing: 16) {
                        Text("⚖️")
                            .font(.system(size: 72))
                        Text("EMPATE!")
                            .font(.system(size: 24, weight: .black))
                            .italic()
                            .foregroundColor(.white)
                        
                        Text("Ninguém foi eliminado. A ronda continua!")
                            .font(.system(size: 17))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }

                Spacer()

                AsmigosButton(
                    title: (vm.recentlyEliminatedPlayer?.isImpostor == true) ? "IR AO MINIJOGO" : "CONTINUAR",
                    color: Color(red: 0.6, green: 0.05, blue: 0.05)
                ) {
                    vm.proceedFromVoteResult()
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 50)
            }
        }
    }
}
