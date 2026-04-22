import SwiftUI

struct MinigameView: View {
    @ObservedObject var vm: GameViewModel

    var body: some View {
        ZStack {
            AsmigosBackground()
            VStack(spacing: 18) {
                Text("Minijogo Final")
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                if vm.impostorEscapeLane == nil {
                    Text("Impostor escolhe para onde fugir")
                        .foregroundStyle(.white.opacity(0.85))
                    laneButtons(action: vm.setImpostorEscapeLane)
                } else if vm.currentHunterIndex < vm.hunters.count {
                    Text("\(vm.currentHunterName()), escolhe para onde disparar")
                        .foregroundStyle(.white.opacity(0.85))
                    laneButtons(action: vm.registerHunterShot)
                } else {
                    Text("Todas as escolhas concluídas")
                        .foregroundStyle(.white.opacity(0.9))
                    PrimaryButton(title: "Ver resultado da ronda") {
                        vm.finishMinigame()
                    }
                }
            }
            .padding(24)
        }
    }

    private func laneButtons(action: @escaping (EscapeLane) -> Void) -> some View {
        VStack(spacing: 10) {
            ForEach(EscapeLane.allCases) { lane in
                PrimaryButton(title: lane.rawValue) {
                    action(lane)
                }
            }
        }
    }
}
