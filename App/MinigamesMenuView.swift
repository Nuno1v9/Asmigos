import SwiftUI

struct MinigamesMenuView: View {
    @EnvironmentObject var vm: GameViewModel
    
    @State private var selectedPongType: GameType? = nil
    @State private var showTapWar = false
    @State private var showCupGame = false
    @State private var showElectricWire = false

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
                    Text("MINIJOGOS 1V1")
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundColor(.white)
                        .tracking(2)
                    Spacer()
                    Color.clear.frame(width: 20)
                }
                .padding(.horizontal, 28)
                .padding(.top, 56)
                
                Spacer()
                
                if vm.selectedMinigames.isEmpty {
                    VStack(spacing: 16) {
                        Text("🤷")
                            .font(.system(size: 56))
                        Text("Nenhum minijogo selecionado!\nVolta ao lobby e escolhe.")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.5))
                            .multilineTextAlignment(.center)
                    }
                } else {
                    VStack(spacing: 16) {
                        ForEach(SessionMinigame.allCases.filter { vm.selectedMinigames.contains($0) }) { game in
                            button(for: game)
                        }
                    }
                    .padding(.horizontal, 40)
                }
                
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showTapWar) {
            TapWarView()
        }
        .fullScreenCover(item: $selectedPongType) { gameType in
            PongHockeyView(gameType: gameType)
        }
        .fullScreenCover(isPresented: $showCupGame) {
            CupGameView()
        }
        .fullScreenCover(isPresented: $showElectricWire) {
            ElectricWireView()
        }
    }
    
    @ViewBuilder
    func button(for game: SessionMinigame) -> some View {
        let color: Color = {
            switch game {
            case .tapWar:       return Color(red: 0.8, green: 0.1, blue: 0.1)
            case .airHockey:    return Color(red: 0.1, green: 0.5, blue: 0.8)
            case .cupGame:      return Color(red: 0.9, green: 0.6, blue: 0.05)
            case .electricWire: return Color(red: 0.9, green: 0.8, blue: 0.1)
            }
        }()
        
        AsmigosButton(title: game.rawValue, color: color) {
            switch game {
            case .tapWar:       showTapWar = true
            case .airHockey:    selectedPongType = .hockey
            case .cupGame:      showCupGame = true
            case .electricWire: showElectricWire = true
            }
        }
    }
}
