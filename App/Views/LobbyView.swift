import SwiftUI

struct LobbyView: View {
    @EnvironmentObject var vm: GameViewModel
    @State private var newName = ""
    @State private var selectedImageName = "1"
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 24) {
                HStack {
                    Button(action: { vm.screen = .menu }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                    }
                    Spacer()
                    AsmigosLogo(size: 28)
                    Spacer()
                    Color.clear.frame(width: 20)
                }
                .padding(.horizontal, 28)
                .padding(.top, 56)

                Text("SALA")
                    .font(.system(size: 13, weight: .heavy))
                    .foregroundColor(.white.opacity(0.4))
                    .tracking(4)

                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(vm.players) { player in
                            PlayerCard(player: player)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        vm.removePlayer(id: player.id)
                                    } label: {
                                        Label("Remover", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 28)
                }

                // Seleção de Minijogos
                VStack(spacing: 10) {
                    HStack {
                        Text("MINIJOGOS DA SESSÃO")
                            .font(.system(size: 11, weight: .heavy))
                            .foregroundColor(.white.opacity(0.35))
                            .tracking(3)
                        Spacer()
                        Text("\(vm.selectedMinigames.count)/\(SessionMinigame.allCases.count)")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white.opacity(0.25))
                    }
                    .padding(.horizontal, 28)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(SessionMinigame.allCases) { game in
                                let isOn = vm.selectedMinigames.contains(game)
                                Button(action: {
                                    if isOn {
                                        vm.selectedMinigames.remove(game)
                                    } else {
                                        vm.selectedMinigames.insert(game)
                                    }
                                }) {
                                    Text(game.rawValue)
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(isOn ? .black : .white.opacity(0.4))
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 10)
                                        .background(isOn ? Color.white : Color(white: 0.12))
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(isOn ? Color.clear : Color.white.opacity(0.1), lineWidth: 1)
                                        )
                                }
                                .animation(.easeOut(duration: 0.15), value: isOn)
                            }
                        }
                        .padding(.horizontal, 28)
                    }
                }

                VStack(spacing: 12) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(1...8, id: \.self) { i in
                                let imgName = "\(i)"
                                Button(action: { selectedImageName = imgName }) {
                                    Image("char_\(imgName)")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .padding(4)
                                        .background(selectedImageName == imgName ? Color.red.opacity(0.3) : Color.clear)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(selectedImageName == imgName ? Color.red : Color.clear, lineWidth: 2)
                                        )
                                }
                            }
                        }
                    }

                    HStack(spacing: 12) {
                        TextField("Nome do jogador", text: $newName)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(Color(white: 0.12))
                            .cornerRadius(8)
                            .textInputAutocapitalization(.words)
                            .submitLabel(.done)
                            .onSubmit(addPlayer)

                        Button(action: addPlayer) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(Color(red: 0.6, green: 0.05, blue: 0.05))
                                .cornerRadius(8)
                        }
                        .disabled(newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 13))
                            .foregroundColor(Color(red: 0.9, green: 0.3, blue: 0.3))
                    }

                    if vm.players.count >= 3 {
                        AsmigosButton(title: "INICIAR JOGO", color: Color(red: 0.6, green: 0.05, blue: 0.05)) {
                            vm.startGame()
                        }
                    } else {
                        Text("Adiciona pelo menos 3 jogadores (\(vm.players.count)/3)")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.35))
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 40)
            }
        }
    }

    func addPlayer() {
        if vm.addPlayer(name: newName, imageName: selectedImageName) {
            newName = ""
            errorMessage = nil
        } else {
            let trimmed = newName.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty {
                errorMessage = "Escreve um nome válido."
            } else {
                errorMessage = "Já existe um jogador com esse nome."
            }
        }
    }
}
