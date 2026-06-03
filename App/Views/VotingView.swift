import SwiftUI

struct VotingView: View {
    @EnvironmentObject var vm: GameViewModel
    @State private var selectedID: UUID?

    private var voter: Player? { vm.currentVoter }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 24) {
                HStack {
                    AsmigosLogo(size: 26)
                    Spacer()
                    Text("Voto \(vm.currentVoterIndex + 1)/\(vm.alivePlayers.count)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.4))
                }
                .padding(.horizontal, 28)
                .padding(.top, 56)

                Text("VOTAÇÃO")
                    .font(.system(size: 11, weight: .heavy))
                    .foregroundColor(.white.opacity(0.35))
                    .tracking(4)

                if let voter {
                    VStack(spacing: 16) {
                        Text("\(voter.name), quem é o impostor?")
                            .font(.system(size: 22, weight: .black))
                            .italic()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Image("char_\(voter.imageName)")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200, maxHeight: 200)
                    }

                    Text("Passa o telemóvel para \(voter.name)")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.35))
                }

                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(vm.alivePlayers.filter { $0.id != voter?.id }) { player in
                            PlayerCard(player: player, isSelected: selectedID == player.id) {
                                selectedID = player.id
                            }
                        }
                    }
                    .padding(.horizontal, 28)
                }

                if let selectedID, let voterID = voter?.id {
                    AsmigosButton(title: "CONFIRMAR VOTO", color: Color(red: 0.6, green: 0.05, blue: 0.05)) {
                        vm.submitVote(voterID: voterID, suspectID: selectedID)
                    }
                    .padding(.horizontal, 28)
                }

                Spacer().frame(height: 40)
            }
        }
        .onChange(of: vm.currentVoterIndex) { _, _ in
            selectedID = nil
        }
    }
}
