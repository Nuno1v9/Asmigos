import Foundation

struct Player: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var imageName: String
    var score: Int = 0
    var lives: Int = 3
    var isImpostor: Bool = false
    var isEliminated: Bool = false
}

struct Question: Codable, Equatable {
    var real: String
    var fake: String
}

enum GameScreen: Equatable {
    case splash, menu, lobby, question, voting, voteResult, impostorChoice, minigame, roundResult, winner, minigamesMenu, bonusMinigame
}

enum BonusContext: Equatable {
    /// Ninguém apanhou o impostor no CATCH — minijogo para perder vida
    case failedCatch
    /// Dois jogadores acertaram no voto — desempate para o ponto
    case correctVotersDuel
}

enum FleeDirection: String, CaseIterable {
    case left, center, right

    var label: String {
        switch self {
        case .left: return "esquerda"
        case .center: return "centro"
        case .right: return "direita"
        }
    }
}

enum GameType: String, Identifiable {
    case hockey
    var id: String { rawValue }
}

/// Minijogos de bónus disponíveis para escolher no lobby
enum SessionMinigame: String, CaseIterable, Identifiable {
    case tapWar       = "TAP WAR 👆"
    case airHockey    = "AIR HOCKEY 🏒"
    case cupGame      = "JOGO DO COPO 🥤"
    case electricWire = "FIO ELÉTRICO ⚡️"

    var id: String { rawValue }

    var color: String {
        switch self {
        case .tapWar:       return "red"
        case .airHockey:    return "blue"
        case .cupGame:      return "orange"
        case .electricWire: return "yellow"
        }
    }
}
