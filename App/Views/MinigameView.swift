import SwiftUI
import Combine

struct MinigameView: View {
    @EnvironmentObject var vm: GameViewModel

    private enum Phase {
        case guessDirection
        case timing
        case result
    }

    @State private var phase: Phase = .guessDirection
    @State private var guessedDirection: FleeDirection?
    @State private var cursorPosition: CGFloat = 0.5
    @State private var isMovingRight = Bool.random()
    @State private var isStopped = false
    @State private var timingHit = false
    @State private var zoneEnlarged = false

    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()

    private var currentPlayer: Player? { vm.currentMinigamePlayer }
    private var impostorFled: FleeDirection { vm.impostorDirection }

    private let speed: CGFloat = 0.035
    private let baseZoneWidth: CGFloat = 0.03
    private var zoneWidth: CGFloat { zoneEnlarged ? baseZoneWidth * 3 : baseZoneWidth }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 0) {
                header

                Spacer()

                VStack(spacing: 24) {
                    Text("TIMING — CATCH!")
                        .font(.system(size: 11, weight: .heavy))
                        .foregroundColor(.white.opacity(0.35))
                        .tracking(4)

                    if let player = currentPlayer {
                        playerHeader(player)
                    }

                    switch phase {
                    case .guessDirection:
                        guessSection
                    case .timing:
                        timingSection
                    case .result:
                        resultSection
                    }
                }

                Spacer()
            }
        }
        .onReceive(timer) { _ in
            guard phase == .timing, !isStopped else { return }
            if isMovingRight {
                cursorPosition += speed
                if cursorPosition >= 1.0 {
                    cursorPosition = 1.0
                    isMovingRight = false
                }
            } else {
                cursorPosition -= speed
                if cursorPosition <= 0.0 {
                    cursorPosition = 0.0
                    isMovingRight = true
                }
            }
        }
        .onChange(of: vm.minigamePlayerIndex) { _, _ in
            resetForNextPlayer()
        }
    }

    private var header: some View {
        HStack {
            AsmigosLogo(size: 26)
            Spacer()
            if !vm.correctVoters.isEmpty {
                Text("Jogador \(vm.minigamePlayerIndex + 1)/\(vm.correctVoters.count)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.4))
            }
        }
        .padding(.horizontal, 28)
        .padding(.top, 56)
    }

    private func playerHeader(_ player: Player) -> some View {
        VStack(spacing: 16) {
            Text("\(player.name), apanha o impostor!")
                .font(.system(size: 22, weight: .black))
                .italic()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Image("char_\(player.imageName)")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 160, maxHeight: 160)
        }
        .padding(.horizontal, 28)
    }

    private var guessSection: some View {
        VStack(spacing: 20) {
            Text("Adivinha para onde o impostor fugiu:")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)

            HStack(spacing: 12) {
                guessButton(.left, label: "⬅️ ESQ")
                guessButton(.center, label: "⬆️ CENTRO")
                guessButton(.right, label: "➡️ DIR")
            }
            .padding(.horizontal, 28)

            if guessedDirection != nil {
                AsmigosButton(title: "IR AO TIMING →", color: Color(red: 0.6, green: 0.05, blue: 0.05)) {
                    withAnimation { phase = .timing }
                }
                .padding(.horizontal, 28)
            }
        }
    }

    private var timingSection: some View {
        VStack(spacing: 20) {
            if let guess = guessedDirection {
                Text("A tua aposta: \(guess.label.uppercased())")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(red: 0.8, green: 0.1, blue: 0.1))
            }

            Text(zoneEnlarged
                 ? "Zona verde x3! Acertaste o timing!"
                 : "Clica CATCH quando o cursor passar na zona VERDE!")
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)

            timingBar
                .frame(height: zoneEnlarged ? 90 : 60)
                .padding(.horizontal, 28)
                .animation(.easeOut(duration: 0.35), value: zoneEnlarged)

            if !isStopped {
                AsmigosButton(title: "CATCH!", color: Color(red: 0.6, green: 0.05, blue: 0.05)) {
                    stopCursor()
                }
                .padding(.horizontal, 28)
            }
        }
    }

    private var resultSection: some View {
        let caught = guessedDirection == impostorFled && timingHit
        return VStack(spacing: 16) {
            Text(caught ? "APANHADO! 🎯" : "ESCAPOU! 💨")
                .font(.system(size: 28, weight: .black))
                .foregroundColor(caught ? .green : .red)
                .italic()

            if timingHit && !caught {
                Text("Timing ok, mas a direção estava errada.")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.5))
            } else if !timingHit && guessedDirection == impostorFled {
                Text("Direção certa, mas falhaste o timing.")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .frame(height: 80)
    }

    private var timingBar: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let center = targetPosition(for: impostorFled)
            let barHeight: CGFloat = zoneEnlarged ? 75 : 50

            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(white: 0.15))
                    .frame(height: barHeight)
                    .cornerRadius(barHeight / 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: barHeight / 2)
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )

                directionMarkers(width: width, barHeight: barHeight)

                Rectangle()
                    .fill(Color.green.opacity(zoneEnlarged ? 1.0 : 0.8))
                    .frame(width: width * zoneWidth, height: barHeight)
                    .offset(x: (center - zoneWidth / 2) * width)
                    .animation(.easeOut(duration: 0.35), value: zoneEnlarged)

                Rectangle()
                    .fill(Color.white)
                    .frame(width: 8, height: barHeight + 10)
                    .cornerRadius(4)
                    .offset(x: cursorPosition * width - 4)
                    .shadow(color: .white, radius: 4)
            }
        }
    }

    private func directionMarkers(width: CGFloat, barHeight: CGFloat) -> some View {
        HStack(spacing: 0) {
            ForEach(FleeDirection.allCases, id: \.self) { dir in
                Text(dir == .left ? "←" : (dir == .center ? "•" : "→"))
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white.opacity(0.2))
                    .frame(width: width / 3)
            }
        }
        .frame(height: barHeight)
    }

    private func guessButton(_ direction: FleeDirection, label: String) -> some View {
        Button { guessedDirection = direction } label: {
            Text(label)
                .font(.system(size: 12, weight: .black))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(guessedDirection == direction ? Color(red: 0.6, green: 0.05, blue: 0.05) : Color(white: 0.15))
                .cornerRadius(8)
        }
    }

    private func targetPosition(for direction: FleeDirection) -> CGFloat {
        switch direction {
        case .left: return 0.2
        case .center: return 0.5
        case .right: return 0.8
        }
    }

    private func stopCursor() {
        isStopped = true
        let center = targetPosition(for: impostorFled)
        let hit = abs(cursorPosition - center) <= zoneWidth / 2
        timingHit = hit

        if hit {
            withAnimation { zoneEnlarged = true }
        }

        phase = .result

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            guard let playerID = currentPlayer?.id, let guess = guessedDirection else { return }
            vm.submitMinigameChoice(playerID: playerID, guessedDirection: guess, timingHit: timingHit)
        }
    }

    private func resetForNextPlayer() {
        phase = .guessDirection
        guessedDirection = nil
        cursorPosition = 0.5
        isMovingRight = Bool.random()
        isStopped = false
        timingHit = false
        zoneEnlarged = false
    }
}
