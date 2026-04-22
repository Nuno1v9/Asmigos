import UIKit

class LobbyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    private let startButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let addPlayerButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupUI() {
        titleLabel.text = "Lobby da Sala"
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        addPlayerButton.setTitle("+ Adicionar Jogador Local", for: .normal)
        addPlayerButton.setTitleColor(.red, for: .normal)
        addPlayerButton.translatesAutoresizingMaskIntoConstraints = false
        addPlayerButton.addTarget(self, action: #selector(addPlayerTapped), for: .touchUpInside)
        
        startButton.setTitle("COMEÇAR", for: .normal)
        startButton.backgroundColor = .red
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 8
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(addPlayerButton)
        view.addSubview(startButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addPlayerButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            addPlayerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: addPlayerButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -20),
            
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 200),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func addPlayerTapped() {
        let alert = UIAlertController(title: "Novo Jogador", message: "Insere o nome do jogador", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Adicionar", style: .default) { _ in
            if let name = alert.textFields?.first?.text, !name.isEmpty {
                GameManager.shared.addPlayer(name: name)
                self.tableView.reloadData()
            }
        })
        present(alert, animated: true)
    }
    
    @objc private func startTapped() {
        if GameManager.shared.players.count >= 3 {
            GameManager.shared.startGame()
            let questionVC = QuestionViewController()
            questionVC.modalPresentationStyle = .fullScreen
            present(questionVC, animated: true)
        } else {
            let alert = UIAlertController(title: "Atenção", message: "Precisas de pelo menos 3 jogadores (MVP).", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameManager.shared.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .darkGray
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = GameManager.shared.players[indexPath.row].name
        return cell
    }
}
