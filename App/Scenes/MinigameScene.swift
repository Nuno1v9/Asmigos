import SpriteKit
import GameplayKit

class MinigameScene: SKScene {
    
    var correctPlayers: [Player] = []
    var imposter: Player?
    var onGameEnd: (() -> Void)?
    
    private var imposterPosition: String?
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        
        let title = SKLabelNode(fontNamed: "Helvetica-Bold")
        title.text = "Fuga do Impostor"
        title.fontSize = 30
        title.fontColor = .red
        title.position = CGPoint(x: frame.midX, y: frame.maxY - 100)
        addChild(title)
        
        // Imposter logic: randomize position (Esquerda, Centro, Direita)
        imposterPosition = ["Esquerda", "Centro", "Direita"].randomElement()
        
        setupPositions()
    }
    
    func setupPositions() {
        // Left, Center, Right choices
        let positions = ["Esquerda", "Centro", "Direita"]
        let xOffsets: [CGFloat] = [-100, 0, 100]
        
        for i in 0..<3 {
            let node = SKShapeNode(rectOf: CGSize(width: 80, height: 80), cornerRadius: 10)
            node.fillColor = .darkGray
            node.position = CGPoint(x: frame.midX + xOffsets[i], y: frame.midY)
            node.name = positions[i]
            addChild(node)
            
            let label = SKLabelNode(fontNamed: "Helvetica")
            label.text = positions[i]
            label.fontSize = 15
            label.verticalAlignmentMode = .center
            label.position = CGPoint(x: frame.midX + xOffsets[i], y: frame.midY)
            addChild(label)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        for node in touchedNodes {
            if let name = node.name {
                print("Escolheu: \(name)")
                
                // Simples logica MVP - O primeiro a carregar decide para onde atirou (como só há um Device, fingimos q é um deles)
                if name == imposterPosition {
                    // Acertou e matou
                    if let winner = correctPlayers.first {
                        GameManager.shared.imposterKilled(by: winner.id)
                        print("\(winner.name) matou o impostor!")
                    }
                } else {
                    // Errou
                    print("Impostor fugiu para \(imposterPosition!)")
                    GameManager.shared.imposterEscaped()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.onGameEnd?()
                }
            }
        }
    }
}
