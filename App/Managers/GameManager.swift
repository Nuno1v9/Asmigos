import Foundation

enum GameState {
    case lobby
    case showingQuestion
    case voting
    case voteResult
    case minigame
    case roundResult
    case gameOver
}

class GameManager {
    static let shared = GameManager()
    
    var players: [Player] = []
    var currentState: GameState = .lobby
    var currentQuestion: Question?
    var imposterId: UUID?
    
    // MVP: Local game logic
    func addPlayer(name: String) {
        players.append(Player(name: name))
    }
    
    func startGame() {
        guard players.count >= 3 else { return } // MVP requires at least 3 players
        
        // Reset scores and roles
        for i in 0..<players.count {
            players[i].score = 0
            players[i].isImposter = false
            players[i].vote = nil
        }
        
        startRound()
    }
    
    func startRound() {
        // Clear votes
        for i in 0..<players.count {
            players[i].vote = nil
        }
        
        // Select Imposter
        let imposterIndex = Int.random(in: 0..<players.count)
        players[imposterIndex].isImposter = true
        imposterId = players[imposterIndex].id
        
        // Get Question
        currentQuestion = QuestionManager.shared.getRandomQuestion()
        
        currentState = .showingQuestion
    }
    
    func submitVote(voterId: UUID, suspectId: UUID) {
        if let index = players.firstIndex(where: { $0.id == voterId }) {
            players[index].vote = suspectId
        }
    }
    
    func checkVotes() -> [Player] {
        var correctGuessers: [Player] = []
        for player in players {
            if !player.isImposter && player.vote == imposterId {
                correctGuessers.append(player)
            }
        }
        return correctGuessers
    }
    
    func imposterEscaped() {
        // Imposter wins round
        if let index = players.firstIndex(where: { $0.id == imposterId }) {
            players[index].score += 1
        }
    }
    
    func imposterKilled(by playerId: UUID) {
        if let index = players.firstIndex(where: { $0.id == playerId }) {
            players[index].score += 1
        }
    }
}
