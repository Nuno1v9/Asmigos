import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    }
    
    private func setupUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Asmigos"
        titleLabel.textColor = .red
        titleLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subLabel = UILabel()
        titleLabel.text = "Descobre quem é que anda a mentir"
        subLabel.textColor = .white
        subLabel.font = UIFont.systemFont(ofSize: 16)
        subLabel.translatesAutoresizingMaskIntoConstraints = false

        let createRoomButton = UIButton(type: .system)
        createRoomButton.setTitle("CRIAR SALA", for: .normal)
        createRoomButton.backgroundColor = .red
        createRoomButton.setTitleColor(.white, for: .normal)
        createRoomButton.layer.cornerRadius = 8
        createRoomButton.translatesAutoresizingMaskIntoConstraints = false
        
        createRoomButton.addTarget(self, action: #selector(createRoomTapped), for: .touchUpInside)
        
        view.addSubview(titleLabel)
        view.addSubview(subLabel)
        view.addSubview(createRoomButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            subLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            createRoomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createRoomButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            createRoomButton.widthAnchor.constraint(equalToConstant: 200),
            createRoomButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func createRoomTapped() {
        let lobbyVC = LobbyViewController()
        lobbyVC.modalPresentationStyle = .fullScreen
        present(lobbyVC, animated: true)
    }
}
