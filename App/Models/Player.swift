import Foundation

struct Player: Identifiable, Equatable {
    let id: UUID
    var name: String
    var score: Int = 0
    var isImposter: Bool = false
    var vote: UUID? = nil
    var alive: Bool = true
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}
