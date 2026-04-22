import Foundation

final class GameViewModel: ObservableObject {
    @Published var phase: GamePhase = .splash
    @Published var players: [Player] = []
    @Published var lobbyCode: String = "0000"
    @Published var hostName: String = "Host"
    @Published var localPlayerName: String = ""
    @Published var currentQuestion: QuestionCard = QuestionCard(
        fakePrompt: "Quem foi mais provável de acabar na prisão?",
        realPrompt: "Quem foi mais provável de destruir o carro todo?"
    )
    @Published var selectedVotes: [UUID: UUID] = [:]
    @Published var announcedText: String = "MOSGUERO"
    @Published var winnerName: String = "MOSGUERO"
    @Published var winnersText: String = ""
    @Published var roundNumber: Int = 1
    @Published var gameOver: Bool = false
    @Published var hunters: [Player] = []
    @Published var currentHunterIndex: Int = 0
    @Published var impostorEscapeLane: EscapeLane?
    @Published var hunterShots: [UUID: EscapeLane] = [:]

    private(set) var impostorID: UUID?
    private var correctVoters: [UUID] = []
    private let sampleNames = ["Zé", "João", "Rui", "Marta", "Inês", "Carlos", "Duda", "Malu"]
    private let questionManager = QuestionManager()
    private let winningScore = 3

    init() {
        moveFromSplash()
    }

    func moveFromSplash() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) { [weak self] in
            self?.phase = .menu
        }
    }

    func createLobby() {
        lobbyCode = String(Int.random(in: 1000...9999))
        if localPlayerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            localPlayerName = "Host"
        }

        hostName = localPlayerName
        players = [Player(name: hostName)]
        addBotsUntilValidCount()
        phase = .lobby
    }

    func joinLobby() {
        if localPlayerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            localPlayerName = "Jogador"
        }

        hostName = "Host"
        players = [Player(name: hostName), Player(name: localPlayerName)]
        addBotsUntilValidCount()
        phase = .lobby
    }

    func addBot() {
        guard players.count < 8 else { return }
        let usedNames = Set(players.map { $0.name })
        let available = sampleNames.first { !usedNames.contains($0) } ?? "Bot \(players.count + 1)"
        players.append(Player(name: available))
    }

    func startRound() {
        guard players.count >= 3 else { return }
        resetRoundState()
        chooseImpostor()
        currentQuestion = questionManager.randomQuestion()
        phase = .question
    }

    func castVote(voter: UUID, target: UUID) {
        selectedVotes[voter] = target
    }

    func finishVoting() {
        guard let impostorID else { return }
        let impostorName = players.first(where: { $0.id == impostorID })?.name ?? "Impostor"
        correctVoters = selectedVotes
            .filter { $0.value == impostorID }
            .map(\.key)

        if !correctVoters.isEmpty {
            announcedText = impostorName
            hunters = players.filter { correctVoters.contains($0.id) && $0.id != impostorID }
            phase = .reveal
        } else {
            announcedText = "Ninguém acertou"
            addPoint(to: impostorID)
            winnerName = impostorName
            winnersText = "\(impostorName) ganhou a ronda."
            phase = .winner
        }
    }

    func goToMinigame() {
        currentHunterIndex = 0
        hunterShots = [:]
        impostorEscapeLane = nil
        phase = .minigame
    }

    func setImpostorEscapeLane(_ lane: EscapeLane) {
        impostorEscapeLane = lane
    }

    func currentHunterName() -> String {
        guard hunters.indices.contains(currentHunterIndex) else { return "" }
        return hunters[currentHunterIndex].name
    }

    func registerHunterShot(_ lane: EscapeLane) {
        guard hunters.indices.contains(currentHunterIndex) else { return }
        let hunter = hunters[currentHunterIndex]
        hunterShots[hunter.id] = lane
        currentHunterIndex += 1
    }

    func finishMinigame() {
        guard let impostorID, let escapeLane = impostorEscapeLane else { return }
        let killers = hunters.filter { hunterShots[$0.id] == escapeLane }

        if let killer = killers.first {
            addPoint(to: killer.id)
            winnerName = killer.name
            winnersText = "\(killer.name) acertou a fuga e ganhou 1 ponto."
        } else {
            addPoint(to: impostorID)
            winnerName = players.first(where: { $0.id == impostorID })?.name ?? "Impostor"
            winnersText = "Ninguém acertou na fuga. O impostor ganhou 1 ponto."
        }

        phase = .winner
    }

    func nextRound() {
        roundNumber += 1
        phase = .lobby
    }

    func backToMenu() {
        localPlayerName = ""
        players = []
        selectedVotes = [:]
        hunters = []
        hunterShots = [:]
        winnersText = ""
        gameOver = false
        roundNumber = 1
        phase = .menu
    }

    func prompt(for player: Player) -> String {
        player.isImpostor ? currentQuestion.fakePrompt : currentQuestion.realPrompt
    }

    private func addBotsUntilValidCount() {
        while players.count < 4 {
            addBot()
        }
    }

    private func resetRoundState() {
        selectedVotes = [:]
        correctVoters = []
        hunters = []
        currentHunterIndex = 0
        hunterShots = [:]
        impostorEscapeLane = nil
        players = players.map {
            var player = $0
            player.isImpostor = false
            return player
        }
    }

    private func chooseImpostor() {
        guard !players.isEmpty else { return }
        let idx = Int.random(in: 0..<players.count)
        players[idx].isImpostor = true
        impostorID = players[idx].id
    }

    private func addPoint(to playerID: UUID) {
        guard let index = players.firstIndex(where: { $0.id == playerID }) else { return }
        players[index].score += 1
        if players[index].score >= winningScore {
            gameOver = true
            winnerName = players[index].name
        }
    }
}
