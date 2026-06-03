import SwiftUI
import SpriteKit

struct ElectricWireView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showGameOver = false
    @State private var finalScore = 0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ElectricWireRepresentable(onGameOver: { score in
                self.finalScore = score
                self.showGameOver = true
            })
            .ignoresSafeArea()
            
            if showGameOver {
                VStack(spacing: 24) {
                    Text("FIM DE JOGO!")
                        .font(.system(size: 32, weight: .black))
                        .foregroundColor(.red)
                    
                    Text("Sobreviveste a \(finalScore) barreiras.")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    
                    Button("SAIR") {
                        dismiss()
                    }
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .cornerRadius(12)
                }
                .padding(40)
                .background(Color.black.opacity(0.8))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 2)
                )
            }
            
            // Botão de fechar (para sair a qualquer momento)
            if !showGameOver {
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

struct ElectricWireRepresentable: UIViewRepresentable {
    var onGameOver: (Int) -> Void
    
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.allowsTransparency = true
        view.ignoresSiblingOrder = true
        
        let scene = ElectricWireScene()
        scene.scaleMode = .resizeFill
        scene.onGameOver = { score in
            DispatchQueue.main.async {
                onGameOver(score)
            }
        }
        
        view.presentScene(scene)
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {}
}
