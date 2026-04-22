import SwiftUI

struct RevealView: View {
    @ObservedObject var vm: GameViewModel

    var body: some View {
        ZStack {
            AsmigosBackground()
            VStack(spacing: 18) {
                Text("Resultado")
                    .font(.title2.bold())
                    .foregroundStyle(.white.opacity(0.85))

                Text(vm.announcedText.uppercased())
                    .font(.system(size: 38, weight: .black))
                    .foregroundStyle(.green)

                PrimaryButton(title: "Continuar") {
                    vm.goToMinigame()
                }
            }
            .padding(24)
        }
    }
}
