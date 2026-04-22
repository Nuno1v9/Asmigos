import UIKit
import SpriteKit

class MinigameViewController: UIViewController {

    var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView = SKView(frame: view.bounds)
        view.addSubview(skView)
        
        let scene = MinigameScene(size: view.bounds.size)
        // Passar contexto para a cena
        scene.correctPlayers = GameManager.shared.checkVotes()
        scene.imposter = GameManager.shared.players.first(where: { $0.id == GameManager.shared.imposterId })
        scene.scaleMode = .resizeFill
        // Closure para quando o minijogo acabar, fechar e voltar aos resultados finais da ronda
        scene.onGameEnd = { [weak self] in
            DispatchQueue.main.async {
                let winnerVC = WinnerViewController()
                winnerVC.modalPresentationStyle = .fullScreen
                self?.present(winnerVC, animated: true)
            }
        }
        
        skView.presentScene(scene)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
