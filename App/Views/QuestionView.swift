import SwiftUI

struct QuestionView: View {
    @ObservedObject var vm: GameViewModel

    var body: some View {
        ZStack {
            AsmigosBackground()
            VStack(spacing: 16) {
                Text("Pergunta")
                    .font(.title.bold())
                    .foregroundStyle(.white)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(vm.players) { player in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(player.name.uppercased())
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.75))
                                Text(vm.prompt(for: player))
                                    .font(.body.weight(.medium))
                                    .foregroundStyle(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .background(AsmigosTheme.panel)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }

                PrimaryButton(title: "Ir para votação") {
                    vm.phase = .voting
                }
            }
            .padding(24)
        }
    }
}
