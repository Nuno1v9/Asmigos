import Foundation

struct Player: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var score: Int = 0
    var isImpostor: Bool = false
}

struct QuestionCard {
    let fakePrompt: String
    let realPrompt: String
}

enum EscapeLane: String, CaseIterable, Identifiable {
    case left = "Esquerda"
    case center = "Centro"
    case right = "Direita"

    var id: String { rawValue }
}

enum GamePhase {
    case splash
    case menu
    case createLobby
    case joinLobby
    case lobby
    case question
    case voting
    case reveal
    case minigame
    case winner
}
