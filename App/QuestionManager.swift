import Foundation

final class QuestionManager {
    static let shared = QuestionManager()

    private let fallback: [Question] = [
        Question(real: "Qual foi o último filme que viste?",
                 fake: "Qual foi o último livro que leste?"),
        Question(real: "Que animal tens em casa?",
                 fake: "Que animal gostarias de ter?"),
        Question(real: "Qual é a tua comida favorita?",
                 fake: "Qual é a comida que mais detestas?"),
        Question(real: "Que música estás a ouvir ultimamente?",
                 fake: "Qual é o teu género musical favorito?"),
        Question(real: "Qual foi o último lugar que visitaste?",
                 fake: "Para onde gostarias de viajar?"),
        Question(real: "Qual é o teu desporto favorito?",
                 fake: "Que desporto praticaste em criança?"),
        Question(real: "O que fizeste no fim de semana passado?",
                 fake: "O que costumas fazer ao fim de semana?"),
        Question(real: "Qual é o teu programa de TV favorito?",
                 fake: "Qual é o teu filme favorito de sempre?"),
        Question(real: "Qual foi o melhor presente que recebeste?",
                 fake: "Qual foi o pior presente que recebeste?"),
        Question(real: "O que fizeste nas últimas férias?",
                 fake: "O que costumas fazer nas férias de verão?"),
    ]

    private let questions: [Question]

    private init() {
        if let url = Bundle.main.url(forResource: "questions", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([Question].self, from: data),
           !decoded.isEmpty {
            let valid = decoded.filter { !$0.real.isEmpty && !$0.fake.isEmpty && $0.real != $0.fake }
            questions = valid.isEmpty ? fallback : valid
        } else {
            questions = fallback
        }
    }

    func randomQuestion() -> Question {
        questions.randomElement() ?? fallback[0]
    }
}
