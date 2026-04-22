import UIKit

class WinnerViewController: UIViewController {

    private let titleLabel = UILabel()
    private let scoresLabel = UILabel()
    private let finishButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        displayScores()
    }
    
    private func setupUI() {
        titleLabel.text = "Resultados da Ronda"
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        scoresLabel.textColor = .red
        scoresLabel.font = .systemFont(ofSize: 20)
        scoresLabel.textAlignment = .center
        scoresLabel.numberOfLines = 0
        scoresLabel.translatesAutoresizingMaskIntoConstraints = false
        
        finishButton.setTitle("FECHAR (NOVA RONDA)", for: .normal)
        finishButton.backgroundColor = .darkGray
        finishButton.setTitleColor(.white, for: .normal)
        finishButton.layer.cornerRadius = 8
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        finishButton.addTarget(self, action: #selector(finishTapped), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(scoresLabel)
        view.addSubview(finishButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scoresLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            scoresLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scoresLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            finishButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            finishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            finishButton.widthAnchor.constraint(equalToConstant: 250),
            finishButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func displayScores() {
        var scoreText = "PONTUAÇÕES:\n\n"
        let sortedPlayers = GameManager.shared.players.sorted { $0.score > $1.score }
        
        for player in sortedPlayers {
            scoreText += "\(player.name): \(player.score) pts\n"
        }
        
        scoresLabel.text = scoreText
    }
    
    @objc private func finishTapped() {
        // Retornar ao MainMenu/Lobby desfazendo o stack modal
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
