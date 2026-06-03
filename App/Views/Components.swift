import SwiftUI

// Logo AsMigos com "As" branco e "migos" vermelho
struct AsmigosLogo: View {
    var size: CGFloat = 48
    var body: some View {
        HStack(spacing: 0) {
            Text("As")
                .font(.system(size: size, weight: .heavy, design: .default))
                .italic()
                .foregroundColor(.white)
            Text("migos")
                .font(.system(size: size, weight: .heavy, design: .default))
                .italic()
                .foregroundColor(Color(red: 0.8, green: 0.1, blue: 0.1))
        }
    }
}

// Botão padrão do jogo
struct AsmigosButton: View {
    var title: String
    var color: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .black))
                .italic()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(color)
                .cornerRadius(8)
        }
    }
}

// Card de jogador
struct PlayerCard: View {
    var player: Player
    var isSelected: Bool = false
    var action: (() -> Void)? = nil

    var body: some View {
        Button(action: { action?() }) {
            HStack {
                Image("char_\(player.imageName)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                Text(player.name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Text("\(player.score) pts")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(isSelected ? Color(red: 0.6, green: 0.05, blue: 0.05) : Color(white: 0.12))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.red : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
