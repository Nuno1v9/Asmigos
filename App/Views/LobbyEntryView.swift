import SwiftUI

struct LobbyEntryView: View {
    @ObservedObject var vm: GameViewModel
    let isCreate: Bool
    @State private var codeInput: String = ""

    var body: some View {
        ZStack {
            AsmigosBackground()
            VStack(spacing: 16) {
                Text(isCreate ? "Criar Lobby" : "Entrar no Lobby")
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                TextField("Nome do jogador", text: $vm.localPlayerName)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()

                if !isCreate {
                    TextField("Código da sala", text: $codeInput)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                }

                PrimaryButton(title: isCreate ? "Criar" : "Entrar") {
                    if isCreate {
                        vm.createLobby()
                    } else {
                        vm.lobbyCode = codeInput.isEmpty ? vm.lobbyCode : codeInput
                        vm.joinLobby()
                    }
                }

                Button("Voltar") {
                    vm.phase = .menu
                }
                .foregroundStyle(.white.opacity(0.75))
                .padding(.top, 4)
            }
            .padding(24)
        }
    }
}
