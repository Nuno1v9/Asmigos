import SwiftUI

struct ImpostorChoiceView: View {
    @EnvironmentObject var vm: GameViewModel
    @State private var selected: FleeDirection?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    AsmigosLogo(size: 26)
                    Spacer()
                }
                .padding(.horizontal, 28)
                .padding(.top, 56)

                Spacer()

                VStack(spacing: 28) {
                    Text("ESCOLHA DO IMPOSTOR")
                        .font(.system(size: 11, weight: .heavy))
                        .foregroundColor(.white.opacity(0.35))
                        .tracking(4)

                    if let impostor = vm.impostor {
                        VStack(spacing: 16) {
                            Text("\(impostor.name), para onde vais fugir?")
                                .font(.system(size: 22, weight: .black))
                                .italic()
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            Image("char_\(impostor.imageName)")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 200, maxHeight: 200)
                        }

                        Text("Escolhe em segredo e depois passa o telemóvel aos outros jogadores")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.35))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 28)
                    }

                    HStack(spacing: 0) {
                        ForEach(["←", "•", "→"], id: \.self) { arrow in
                            Text(arrow)
                                .font(.system(size: 48, weight: .black))
                                .foregroundColor(.white.opacity(0.3))
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.vertical, 12)

                    HStack(spacing: 12) {
                        directionButton(.left, label: "⬅️ ESQ")
                        directionButton(.center, label: "⬆️ CENTRO")
                        directionButton(.right, label: "➡️ DIR")
                    }
                    .padding(.horizontal, 28)

                    if let selected {
                        AsmigosButton(title: "CONFIRMAR FUGA", color: Color(red: 0.6, green: 0.05, blue: 0.05)) {
                            vm.submitImpostorChoice(direction: selected)
                        }
                        .padding(.horizontal, 28)
                    }
                }

                Spacer()
            }
        }
    }

    private func directionButton(_ direction: FleeDirection, label: String) -> some View {
        Button(action: { selected = direction }) {
            Text(label)
                .font(.system(size: 13, weight: .black))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(selected == direction ? Color(red: 0.6, green: 0.05, blue: 0.05) : Color(white: 0.15))
                .cornerRadius(8)
        }
    }
}
