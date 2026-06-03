import SwiftUI
import SpriteKit

struct PongHockeyView: View {
    @Environment(\.dismiss) var dismiss
    let gameType: GameType
    var player1Name: String = "Jogador 1"
    var player2Name: String = "Jogador 2"
    var onComplete: ((Int) -> Void)? = nil

    @State private var winner: Int? = nil // 1 for Player 1 (Bottom), 2 for Player 2 (Top)
    
    var scene: PongHockeyScene {
        let sc = PongHockeyScene(gameType: gameType)
        sc.size = UIScreen.main.bounds.size
        sc.scaleMode = .resizeFill
        sc.onGameOver = { winningPlayer in
            DispatchQueue.main.async {
                self.winner = winningPlayer
            }
        }
        return sc
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            if let winner = winner {
                VStack(spacing: 24) {
                    Text("\(winner == 1 ? player1Name : player2Name) ganhou!")
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(winner == 1 ? Color.red.opacity(0.8) : Color.blue.opacity(0.8))
                        .cornerRadius(12)
                    
                    Button(onComplete == nil ? "SAIR" : "Continuar") {
                        if let onComplete {
                            onComplete(winner)
                        }
                        dismiss()
                    }
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .cornerRadius(12)
                }
                .rotationEffect(.degrees(winner == 2 ? 180 : 0)) // Rotate overlay if player 2 won so they can read it!
            }
            
            // Botão de fechar (para sair a qualquer momento)
            if winner == nil {
                VStack {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white.opacity(0.5))
                                .padding()
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
    }
}
