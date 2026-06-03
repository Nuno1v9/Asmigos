import SwiftUI
import Combine

struct TapWarView: View {
    @Environment(\.dismiss) var dismiss

    var player1Name: String = "Jogador 1"
    var player2Name: String = "Jogador 2"
    var onComplete: ((Int) -> Void)? = nil

    @State private var p1Score = 0
    @State private var p2Score = 0
    
    @State private var timeRemaining = 10.0
    @State private var isPlaying = false
    @State private var hasFinished = false
    
    // Timer para descontar 0.1s de cada vez
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Player 2 Half (Top - Rotated)
                ZStack {
                    Color(red: 0.1, green: 0.3, blue: 0.8).opacity(0.8).ignoresSafeArea()
                    VStack {
                        Spacer()
                        Text("\(p2Score)")
                            .font(.system(size: 80, weight: .black))
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                .rotationEffect(.degrees(180))
                .contentShape(Rectangle())
                .onTapGesture {
                    if isPlaying { p2Score += 1 }
                }
                
                // Divisória / Controles (Center)
                ZStack {
                    Color.white.frame(height: 80)
                    
                    if !isPlaying && !hasFinished {
                        Button(action: {
                            isPlaying = true
                        }) {
                            Text("START TAP WAR")
                                .font(.system(size: 24, weight: .black))
                                .foregroundColor(.black)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Color.yellow)
                                .cornerRadius(20)
                        }
                    } else if hasFinished {
                        VStack(spacing: 4) {
                            Text(finishMessage)
                                .font(.system(size: 20, weight: .black))
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)

                            Button(onComplete == nil ? "Sair" : "Continuar") {
                                finishAndDismiss()
                            }
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.blue)
                        }
                    } else {
                        Text(String(format: "%.1f", timeRemaining))
                            .font(.system(size: 32, weight: .heavy))
                            .foregroundColor(.black)
                    }
                }
                .frame(height: 80)
                .zIndex(1)
                
                // Player 1 Half (Bottom)
                ZStack {
                    Color(red: 0.8, green: 0.1, blue: 0.1).opacity(0.8).ignoresSafeArea()
                    VStack {
                        Spacer()
                        Text("\(p1Score)")
                            .font(.system(size: 80, weight: .black))
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if isPlaying { p1Score += 1 }
                }
            }
        }
        .onReceive(timer) { _ in
            if isPlaying {
                if timeRemaining > 0 {
                    timeRemaining -= 0.1
                } else {
                    timeRemaining = 0
                    isPlaying = false
                    hasFinished = true
                }
            }
        }
    }

    private var finishMessage: String {
        if p1Score > p2Score { return "\(player1Name) ganhou!" }
        if p2Score > p1Score { return "\(player2Name) ganhou!" }
        return "Empate!"
    }

    private var winnerSlot: Int {
        if p1Score > p2Score { return 1 }
        if p2Score > p1Score { return 2 }
        return 0
    }

    private func finishAndDismiss() {
        if let onComplete, winnerSlot > 0 {
            onComplete(winnerSlot)
        }
        dismiss()
    }
}
