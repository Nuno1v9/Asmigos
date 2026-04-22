import Foundation

class QuestionManager {
    static let shared = QuestionManager()
    
    private let questions: [Question] = [
        Question(text: "Quem é o mais provável de acabar na prisão?", targetImposterText: "Quem é o mais provável de estourar o carro todo?"),
        Question(text: "Quem é o mais provável de adormecer numa festa?", targetImposterText: "Quem é o mais provável de esquecer o aniversário do melhor amigo?"),
        Question(text: "Quem é o mais provável de ficar rico?", targetImposterText: "Quem é o mais provável de perder a carteira amanhã?")
    ]
    
    func getRandomQuestion() -> Question {
        return questions.randomElement() ?? questions[0]
    }
}
