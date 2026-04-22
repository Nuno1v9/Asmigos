import UIKit

class VoteResultViewController: UIViewController {
    
    private let resultLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let continueButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        evaluateResults()
    }
    
    private func setupUI() {
        resultLabel.textColor = .white
        resultLabel.font = .boldSystemFont(ofSize: 28)
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 0
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.textColor = .red
        descriptionLabel.font = .systemFont(ofSize: 20)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        continueButton.setTitle("CONTINUAR", for: .normal)
        continueButton.backgroundColor = .red
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.layer.cornerRadius = 8
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        
        view.addSubview(resultLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            resultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.widthAnchor.constraint(equalToConstant: 200),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func evaluateResults() {
        let correctGuessers = GameManager.shared.checkVotes()
        let imposter = GameManager.shared.players.first(where: { $0.id == GameManager.shared.imposterId })
        let imposterName = imposter?.name ?? "Desconhecido"
        
        if correctGuessers.isEmpty {
            resultLabel.text = "O Impostor Ganhou!"
            descriptionLabel.text = "Ninguém descobriu que era o \(imposterName).\nGanha 1 ponto."
            GameManager.shared.imposterEscaped()
            continueButton.setTitle("PRÓXIMA RONDA", for: .normal)
        } else {
            resultLabel.text = "O Impostor foi Descoberto!"
            let names = correctGuessers.map({ $0.name }).joined(separator: ", ")
            descriptionLabel.text = "O impostor era o \(imposterName)!\n\(names) acertaram e vão para o minijogo!"
            continueButton.setTitle("MINIJOGO", for: .normal)
        }
    }
    
    @objc private func continueTapped() {
        let correctGuessers = GameManager.shared.checkVotes()
        if correctGuessers.isEmpty {
            // Ninguém acertou, voltamos ao lobby ou nova ronda
            view.window?.rootViewController?.dismiss(animated: true, completion: nil) // Simplificação p/ MVP: volta atrás
        } else {
            // Minijogo
            let minigameVC = MinigameViewController()
            minigameVC.modalPresentationStyle = .fullScreen
            present(minigameVC, animated: true)
        }
    }
}
