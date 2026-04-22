import UIKit

class QuestionViewController: UIViewController {

    private let titleLabel = UILabel()
    private let questionLabel = UILabel()
    private let nextButton = UIButton(type: .system)
    
    // Para MVP local, vamos passar telemóvel de mão em mão
    private var currentPlayerIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        showCurrentPlayer()
    }
    
    private func setupUI() {
        titleLabel.textColor = .red
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        questionLabel.textColor = .white
        questionLabel.font = .systemFont(ofSize: 22, weight: .medium)
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 0
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nextButton.setTitle("PRÓXIMO", for: .normal)
        nextButton.backgroundColor = .red
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 8
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(questionLabel)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            questionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func showCurrentPlayer() {
        let player = GameManager.shared.players[currentPlayerIndex]
        titleLabel.text = "Passa o tlm a: \(player.name)"
        
        if player.isImposter, let altQ = GameManager.shared.currentQuestion?.targetImposterText {
            questionLabel.text = altQ
        } else {
            questionLabel.text = GameManager.shared.currentQuestion?.text ?? "Sem pergunta"
        }
    }
    
    @objc private func nextTapped() {
        currentPlayerIndex += 1
        
        if currentPlayerIndex < GameManager.shared.players.count {
            // Esconder pergunta antes de passar (para ngm cuscar)
            let alert = UIAlertController(title: "Atenção", message: "Passa o telemóvel ao próximo jogador antes de continuar.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.showCurrentPlayer()
            }))
            present(alert, animated: true)
        } else {
            // Acabaram os jogadores, ir para votação
            let alert = UIAlertController(title: "Hora de Votar!", message: "Todos viram as perguntas. Vamos decidir quem é o impostor.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Vamos lá", style: .default, handler: { _ in
                let votingVC = VotingViewController()
                votingVC.modalPresentationStyle = .fullScreen
                self.present(votingVC, animated: true)
            }))
            present(alert, animated: true)
        }
    }
}
