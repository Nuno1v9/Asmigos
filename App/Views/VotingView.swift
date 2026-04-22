import SwiftUI

struct VotingView: View {
    @ObservedObject var vm: GameViewModel
    @State private var voterIndex: Int = 0
    @State private var selectedTarget: UUID?

    var body: some View {
        ZStack {
            AsmigosBackground()
            VStack(spacing: 16) {
                Text("Votação")
                    .font(.title.bold())
                    .foregroundStyle(.white)

                if vm.players.indices.contains(voterIndex) {
                    Text("Quem é o impostor para \(vm.players[voterIndex].name)?")
                        .foregroundStyle(.white.opacity(0.85))
                }

                VStack(spacing: 10) {
                    ForEach(vm.players) { player in
                        Button {
                            selectedTarget = player.id
                        } label: {
                            HStack {
                                Text(player.name.uppercased())
                                    .foregroundStyle(.white)
                                Spacer()
                                if selectedTarget == player.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                }
                            }
                            .padding(12)
                            .background(AsmigosTheme.panel)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }

                PrimaryButton(title: voterIndex == vm.players.count - 1 ? "Finalizar votos" : "Próximo votante") {
                    guard vm.players.indices.contains(voterIndex), let selectedTarget else { return }
                    let voterID = vm.players[voterIndex].id
                    vm.castVote(voter: voterID, target: selectedTarget)
                    self.selectedTarget = nil
                    if voterIndex < vm.players.count - 1 {
                        voterIndex += 1
                    } else {
                        vm.finishVoting()
                    }
                }
            }
            .padding(24)
        }
    }
}
