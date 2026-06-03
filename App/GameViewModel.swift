import SwiftUI
import Combine

@MainActor
final class GameViewModel: ObservableObject {
    @Published var screen: GameScreen = .menu
    @Published var players: [Player] = []
    @Published var selectedMinigames: Set<SessionMinigame> = Set(SessionMinigame.allCases)
    @Published var currentQuestion: Question?
    @Published var impostorIndex: Int = 0
    @Published var votes: [UUID: UUID] = [:]
    @Published var correctVoters: [Player] = []
    @Published var impostorDirection: FleeDirection = .center
    @Published var shooterChoices: [UUID: FleeDirection] = [:]
    @Published var shooterTimingHits: [UUID: Bool] = [:]
    @Published var roundWinners: [Player] = []
    @Published var currentVoterIndex: Int = 0
    @Published var minigamePlayerIndex: Int = 0
    @Published private(set) var roundID = UUID()
    @Published var recentlyEliminatedPlayer: Player?
    
    @Published var bonusPlayers: [Player] = []
    @Published var selectedBonusMinigame: SessionMinigame? = nil
    @Published var bonusContext: BonusContext = .failedCatch

    let winScore = 3

    var impostor: Player? {
        guard impostorIndex < players.count else { return nil }
        return players[impostorIndex]
    }

    var alivePlayers: [Player] {
        players.filter { !$0.isEliminated }
    }

    var currentVoter: Player? {
        guard currentVoterIndex < alivePlayers.count else { return nil }
        return alivePlayers[currentVoterIndex]
    }

    var currentMinigamePlayer: Player? {
        guard minigamePlayerIndex < correctVoters.count else { return nil }
        return correctVoters[minigamePlayerIndex]
    }

    func addPlayer(name: String, imageName: String) -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        guard !players.contains(where: { $0.name.caseInsensitiveCompare(trimmed) == .orderedSame }) else {
            return false
        }
        players.append(Player(name: trimmed, imageName: imageName))
        return true
    }

    func removePlayer(id: UUID) {
        players.removeAll { $0.id == id }
    }

    func startGame() {
        guard players.count >= 3 else { return }
        for index in players.indices {
            players[index].score = 0
            players[index].isImpostor = false
            players[index].isEliminated = false
            players[index].lives = 3
        }
        startRound()
    }

    func startRound() {
        guard players.count >= 3 else { return }

        roundID = UUID()
        impostorIndex = Int.random(in: 0..<players.count)
        for index in players.indices {
            players[index].isImpostor = (index == impostorIndex)
            players[index].isEliminated = false
            players[index].lives = 3
        }
        votes = [:]
        correctVoters = []
        shooterChoices = [:]
        shooterTimingHits = [:]
        roundWinners = []
        currentVoterIndex = 0
        minigamePlayerIndex = 0
        impostorDirection = .center
        recentlyEliminatedPlayer = nil
        bonusContext = .failedCatch
        currentQuestion = QuestionManager.shared.randomQuestion()
        screen = .question
    }

    func advanceToVoting() {
        votes = [:]
        currentVoterIndex = 0
        screen = .voting
    }

    func submitVote(voterID: UUID, suspectID: UUID) {
        votes[voterID] = suspectID
        if currentVoterIndex < alivePlayers.count - 1 {
            currentVoterIndex += 1
        } else {
            computeVoteResult()
        }
    }

    func computeVoteResult() {
        for (voterID, suspectID) in votes {
            guard let voterIndex = players.firstIndex(where: { $0.id == voterID }),
                  let suspectIndex = players.firstIndex(where: { $0.id == suspectID }) else { continue }
            
            if !players[voterIndex].isImpostor && !players[suspectIndex].isImpostor {
                players[voterIndex].lives -= 1
                if players[voterIndex].lives <= 0 {
                    players[voterIndex].isEliminated = true
                }
            }
        }

        var voteCounts: [UUID: Int] = [:]
        for suspectID in votes.values {
            voteCounts[suspectID, default: 0] += 1
        }
        
        let maxVotes = voteCounts.values.max() ?? 0
        let playersWithMaxVotes = voteCounts.filter { $0.value == maxVotes }.map { $0.key }
        
        if playersWithMaxVotes.count == 1, let eliminatedID = playersWithMaxVotes.first {
            guard let index = players.firstIndex(where: { $0.id == eliminatedID }) else { return }
            recentlyEliminatedPlayer = players[index]
            
            if players[index].isImpostor {
                correctVoters = alivePlayers.filter { votes[$0.id] == eliminatedID && !$0.isEliminated }
            } else {
                correctVoters = []
                let aliveCivilians = alivePlayers.filter { !$0.isImpostor }
                if aliveCivilians.count <= 1 {
                    if let impIndex = players.firstIndex(where: { $0.isImpostor }) {
                        players[impIndex].score += 1
                        roundWinners = [players[impIndex]]
                    }
                }
            }
        } else {
            recentlyEliminatedPlayer = nil
        }
        
        screen = .voteResult
    }

    func proceedFromVoteResult() {
        if let elim = recentlyEliminatedPlayer {
            if elim.isImpostor {
                if correctVoters.isEmpty {
                    screen = .roundResult
                } else {
                    screen = .impostorChoice
                }
            } else {
                let aliveCivilians = alivePlayers.filter { !$0.isImpostor }
                if aliveCivilians.count <= 1 {
                    screen = .roundResult
                } else {
                    currentVoterIndex = 0
                    screen = .question
                }
            }
        } else {
            currentVoterIndex = 0
            screen = .question
        }
    }

    func submitImpostorChoice(direction: FleeDirection) {
        impostorDirection = direction
        minigamePlayerIndex = 0
        shooterChoices = [:]
        shooterTimingHits = [:]
        screen = .minigame
    }

    private func pickCorrectVotersDuelMinigame() -> SessionMinigame {
        .tapWar
    }

    func submitCorrectVotersDuelWinner(winnerID: UUID) {
        guard let winner = players.first(where: { $0.id == winnerID }) else { return }
        roundWinners = [winner]

        if let impIndex = players.firstIndex(where: { $0.isImpostor }) {
            players[impIndex].lives -= 1
            if players[impIndex].lives <= 0 {
                players[impIndex].isEliminated = true
            }
        }

        if let index = players.firstIndex(where: { $0.id == winner.id }) {
            players[index].score += 1
        }
        screen = .roundResult
    }

    func submitMinigameChoice(playerID: UUID, guessedDirection: FleeDirection, timingHit: Bool) {
        shooterChoices[playerID] = guessedDirection
        shooterTimingHits[playerID] = timingHit
        if minigamePlayerIndex < correctVoters.count - 1 {
            minigamePlayerIndex += 1
        } else {
            computeMinigameResult()
        }
    }

    func computeMinigameResult() {
        let catchers = correctVoters.filter { voter in
            guard let guess = shooterChoices[voter.id] else { return false }
            let timing = shooterTimingHits[voter.id] ?? false
            return guess == impostorDirection && timing
        }

        if catchers.isEmpty {
            let candidates = alivePlayers
            bonusPlayers = Array(candidates.shuffled().prefix(2))
            bonusContext = .failedCatch
            selectedBonusMinigame = .tapWar
            screen = .bonusMinigame
            return
        }

        if let impIndex = players.firstIndex(where: { $0.isImpostor }) {
            players[impIndex].lives -= 1
            if players[impIndex].lives <= 0 {
                players[impIndex].isEliminated = true
            }
        }

        // Dois acertaram no voto e ambos apanharam → desempate Tap War
        if correctVoters.count == 2, catchers.count == 2 {
            roundWinners = []
            bonusPlayers = catchers
            bonusContext = .correctVotersDuel
            selectedBonusMinigame = pickCorrectVotersDuelMinigame()
            screen = .bonusMinigame
            return
        }

        roundWinners = catchers
        for winner in roundWinners {
            guard let index = players.firstIndex(where: { $0.id == winner.id }) else { continue }
            players[index].score += 1
        }
        screen = .roundResult
    }

    func submitBonusResult(loserID: UUID) {
        if let index = players.firstIndex(where: { $0.id == loserID }) {
            players[index].lives -= 1
            if players[index].lives <= 0 {
                players[index].isEliminated = true
            }
        }
        proceedFromRoundResult()
    }

    func proceedFromRoundResult() {
        if players.contains(where: { $0.score >= winScore }) {
            screen = .winner
        } else {
            startRound()
        }
    }

    func overallWinner() -> Player? {
        let topScore = players.map(\.score).max() ?? 0
        let leaders = players.filter { $0.score == topScore }
        return leaders.count == 1 ? leaders.first : nil
    }

    func winners() -> [Player] {
        let topScore = players.map(\.score).max() ?? 0
        return players.filter { $0.score == topScore && $0.score >= winScore }
    }

    func resetToMenu() {
        players = []
        screen = .menu
    }
}
