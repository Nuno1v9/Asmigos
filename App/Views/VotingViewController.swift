import UIKit

class VotingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let titleLabel = UILabel()
    private let tableView = UITableView()
    
    private var votingPlayerIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        updateTurn()
    }
    
    private func setupUI() {
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func updateTurn() {
        let voter = GameManager.shared.players[votingPlayerIndex]
        titleLabel.text = "Vez de \(voter.name) votar.\nQuem achas que é o impostor?"
        tableView.reloadData()
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameManager.shared.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let suspect = GameManager.shared.players[indexPath.row]
        let voter = GameManager.shared.players[votingPlayerIndex]
        
        // Não podes votar em ti próprio (Opcional, mas comum em jogos sociais)
        if suspect.id == voter.id {
            cell.textLabel?.text = "\(suspect.name) (Tu)"
            cell.textLabel?.textColor = .gray
            cell.isUserInteractionEnabled = false
        } else {
            cell.textLabel?.text = suspect.name
            cell.textLabel?.textColor = .red
            cell.isUserInteractionEnabled = true
        }
        
        cell.backgroundColor = .darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let voter = GameManager.shared.players[votingPlayerIndex]
        let suspect = GameManager.shared.players[indexPath.row]
        
        GameManager.shared.submitVote(voterId: voter.id, suspectId: suspect.id)
        
        votingPlayerIndex += 1
        
        if votingPlayerIndex < GameManager.shared.players.count {
            let alert = UIAlertController(title: "Passa o telemóvel", message: "Agora é a vez de \(GameManager.shared.players[votingPlayerIndex].name) votar.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.updateTurn()
            }))
            present(alert, animated: true)
        } else {
            // Todos votaram
            let resultVC = VoteResultViewController()
            resultVC.modalPresentationStyle = .fullScreen
            present(resultVC, animated: true)
        }
    }
}
