import SwiftUI
import Combine

struct CupGameView: View {
    @Environment(\.dismiss) var dismiss
    
    // Estado do jogo
    @State private var activeSide: Side = .left        // Qual lado está ativo agora
    @State private var timeLimit: Double = 2.0          // Tempo para reagir (começa em 2s)
    @State private var timeRemaining: Double = 2.0      // Tempo atual a contar
    @State private var isRunning: Bool = false
    @State private var loser: Int? = nil                // 1 = P1 perdeu, 2 = P2 perdeu
    @State private var speed: Double = 1.0              // multiplicador de velocidade visual
    @State private var level: Int = 1
    @State private var flash: Bool = false              // Para o efeito de flash no clique errado
    
    // Timer de alta frequência
    let ticker = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()
    
    enum Side { case left, right }
    
    // P1 controla a metade de baixo (lado esquerdo), P2 controla a metade de cima (lado direito)
    // Mas no "jogo do copo" ambos jogam no mesmo ecrã lado a lado
    // P1 está na parte de baixo do ecrã (rotated) e P2 em cima
    // Mecânica: o "copo" passa de um lado ao outro — cada jogador tem de clicar no momento certo

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()
                
                if !isRunning && loser == nil {
                    startScreen
                } else if let loser = loser {
                    loserScreen(loser: loser)
                } else {
                    gameScreen(geo: geo)
                }
            }
        }
        .onReceive(ticker) { _ in
            guard isRunning, loser == nil else { return }
            
            timeRemaining -= 0.016
            if timeRemaining <= 0 {
                // Quem é que devia ter clicado?
                // Se activeSide == .left, era o P1 (lado esquerdo)
                // Se activeSide == .right, era o P2 (lado direito)
                withAnimation(.easeOut(duration: 0.1)) {
                    loser = (activeSide == .left) ? 1 : 2
                }
                isRunning = false
            }
        }
    }
    
    var startScreen: some View {
        VStack(spacing: 40) {
            Text("🥤")
                .font(.system(size: 80))
            Text("JOGO DO COPO")
                .font(.system(size: 32, weight: .black))
                .italic()
                .foregroundColor(.white)
            
            Text("Clica no lado correto antes do tempo acabar.\nA cada ronda fica 2x mais rápido!")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            VStack(spacing: 12) {
                HStack(spacing: 20) {
                    VStack {
                        Text("P1")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.red)
                        Text("← Esquerda")
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Text("VS")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.white.opacity(0.4))
                    VStack {
                        Text("P2")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.blue)
                        Text("Direita →")
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
            
            Button(action: startGame) {
                Text("COMEÇAR")
                    .font(.system(size: 22, weight: .black))
                    .foregroundColor(.black)
                    .padding(.horizontal, 48)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .cornerRadius(20)
            }
            
            Button("SAIR") { dismiss() }
                .foregroundColor(.white.opacity(0.4))
        }
    }
    
    func gameScreen(geo: GeometryProxy) -> some View {
        let progress = timeRemaining / timeLimit
        
        return ZStack {
            // Fundo dividido
            HStack(spacing: 0) {
                // Lado Esquerdo (P1)
                ZStack {
                    let isActive = (activeSide == .left)
                    Rectangle()
                        .fill(isActive ? Color.red.opacity(0.15 + progress * 0.5) : Color(white: 0.05))
                    
                    VStack(spacing: 16) {
                        Text("P1")
                            .font(.system(size: 18, weight: .heavy))
                            .foregroundColor(isActive ? .red : .white.opacity(0.2))
                        
                        if isActive {
                            Text("🥤")
                                .font(.system(size: 56))
                                .scaleEffect(1.0 + (1.0 - progress) * 0.4)
                            
                            // Barra de tempo
                            VStack(spacing: 6) {
                                GeometryReader { barGeo in
                                    ZStack(alignment: .leading) {
                                        Capsule().fill(Color.white.opacity(0.1))
                                        Capsule()
                                            .fill(progressColor(progress))
                                            .frame(width: barGeo.size.width * progress)
                                    }
                                }
                                .frame(height: 8)
                                .padding(.horizontal, 20)
                                
                                Text(String(format: "%.1fs", max(0, timeRemaining)))
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        } else {
                            Text("✋")
                                .font(.system(size: 40))
                                .opacity(0.3)
                        }
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    handleTap(side: .left)
                }
                
                // Divisória
                Rectangle()
                    .fill(Color.white.opacity(0.15))
                    .frame(width: 2)
                
                // Lado Direito (P2)
                ZStack {
                    let isActive = (activeSide == .right)
                    Rectangle()
                        .fill(isActive ? Color.blue.opacity(0.15 + progress * 0.5) : Color(white: 0.05))
                    
                    VStack(spacing: 16) {
                        Text("P2")
                            .font(.system(size: 18, weight: .heavy))
                            .foregroundColor(isActive ? .blue : .white.opacity(0.2))
                        
                        if isActive {
                            Text("🥤")
                                .font(.system(size: 56))
                                .scaleEffect(1.0 + (1.0 - progress) * 0.4)
                            
                            VStack(spacing: 6) {
                                GeometryReader { barGeo in
                                    ZStack(alignment: .leading) {
                                        Capsule().fill(Color.white.opacity(0.1))
                                        Capsule()
                                            .fill(progressColor(progress))
                                            .frame(width: barGeo.size.width * progress)
                                    }
                                }
                                .frame(height: 8)
                                .padding(.horizontal, 20)
                                
                                Text(String(format: "%.1fs", max(0, timeRemaining)))
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        } else {
                            Text("✋")
                                .font(.system(size: 40))
                                .opacity(0.3)
                        }
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    handleTap(side: .right)
                }
            }
            .ignoresSafeArea()
            
            // Nível e velocidade no centro em cima
            VStack {
                HStack {
                    Spacer()
                    VStack(spacing: 2) {
                        Text("NÍVEL \(level)")
                            .font(.system(size: 13, weight: .heavy))
                            .foregroundColor(.white.opacity(0.6))
                        Text(String(format: "%.2fs", timeLimit))
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white.opacity(0.3))
                    }
                    Spacer()
                }
                .padding(.top, 56)
                Spacer()
            }
        }
        .overlay(
            // Flash de erro
            flash ? Color.white.opacity(0.4).ignoresSafeArea() : Color.clear.ignoresSafeArea()
        )
        .animation(.easeOut(duration: 0.12), value: activeSide)
    }
    
    func loserScreen(loser: Int) -> some View {
        VStack(spacing: 32) {
            Text("💀")
                .font(.system(size: 80))
            
            Text("JOGADOR \(loser) PERDEU!")
                .font(.system(size: 32, weight: .black))
                .italic()
                .foregroundColor(loser == 1 ? .red : .blue)
            
            Text("Nível atingido: \(level)")
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.5))
            
            Text(levelTitle(level: level))
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.35))
            
            VStack(spacing: 16) {
                Button(action: restartGame) {
                    Text("JOGAR DE NOVO")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(.black)
                        .padding(.horizontal, 48)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(20)
                }
                
                Button("SAIR") { dismiss() }
                    .foregroundColor(.white.opacity(0.4))
            }
        }
    }
    
    // MARK: - Logic
    
    func handleTap(side: Side) {
        guard isRunning, loser == nil else { return }
        
        if side == activeSide {
            // Clique correto! Passa para o outro lado e duplica a velocidade
            let nextSide: Side = (activeSide == .left) ? .right : .left
            
            // Duplicar a velocidade a cada nível
            let newTimeLimit = max(0.15, timeLimit * 0.6) // Reduz 40% em vez de 50% para ser mais justo no início
            
            withAnimation(.easeOut(duration: 0.1)) {
                activeSide = nextSide
                timeLimit = newTimeLimit
                timeRemaining = newTimeLimit
                level += 1
            }
        } else {
            // Clique no lado errado!
            triggerWrongTap(wrongSide: side)
        }
    }
    
    func triggerWrongTap(wrongSide: Side) {
        withAnimation(.easeOut(duration: 0.1)) {
            flash = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            flash = false
            loser = (wrongSide == .left) ? 1 : 2
            isRunning = false
        }
    }
    
    func startGame() {
        timeLimit = 2.0
        timeRemaining = 2.0
        activeSide = Bool.random() ? .left : .right
        level = 1
        loser = nil
        isRunning = true
    }
    
    func restartGame() {
        startGame()
    }
    
    func progressColor(_ progress: Double) -> Color {
        if progress > 0.5 { return .green }
        if progress > 0.25 { return .orange }
        return .red
    }
    
    func levelTitle(level: Int) -> String {
        switch level {
        case 1...3: return "Principiante 🐣"
        case 4...6: return "A esquentar 🔥"
        case 7...10: return "Bom reflexo! ⚡"
        case 11...15: return "Insano! 🤯"
        default: return "Lendário! 👑"
        }
    }
}
