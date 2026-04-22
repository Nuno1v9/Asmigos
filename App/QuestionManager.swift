import Foundation

struct QuestionManager {
    private let fallbackQuestions: [QuestionCard] = [
        QuestionCard(
            fakePrompt: "Quem foi mais provável de acabar na prisão?",
            realPrompt: "Quem foi mais provável de destruir o carro todo?"
        ),
        QuestionCard(
            fakePrompt: "Quem foi mais provável de fingir estar doente?",
            realPrompt: "Quem foi mais provável de faltar ao trabalho por preguiça?"
        ),
        QuestionCard(
            fakePrompt: "Quem foi mais provável de gastar tudo em festas?",
            realPrompt: "Quem foi mais provável de estourar tudo em comida?"
        )
    ]

    func randomQuestion() -> QuestionCard {
        let cards = loadQuestions()
        return cards.randomElement() ?? fallbackQuestions[0]
    }

    private func loadQuestions() -> [QuestionCard] {
        guard
            let url = Bundle.main.url(forResource: "questions", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let decoded = try? JSONDecoder().decode([QuestionPayload].self, from: data)
        else {
            return fallbackQuestions
        }

        let cards = decoded.map { QuestionCard(fakePrompt: $0.fake, realPrompt: $0.real) }
        return cards.isEmpty ? fallbackQuestions : cards
    }
}

private struct QuestionPayload: Decodable {
    let fake: String
    let real: String
}
