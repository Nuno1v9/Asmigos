# 🎮 Asmigos

## ⚡ Elevator Pitch
Um jogo social rápido onde um impostor tenta enganar os outros jogadores. No fim de cada ronda, os jogadores votam em quem acham que é o impostor, e quem acertar pode tentar abatê-lo num minijogo de escolhas.

---

## 💡 Game Concept
O jogo é inspirado em jogos de “Impostor”.  
Em cada ronda, um jogador é o impostor e tenta esconder a sua identidade. Os restantes jogadores recebem uma pergunta e tentam descobrir quem está a fingir.

Depois da fase de respostas, todos votam em quem acham que é o impostor.

- Se ninguém votar corretamente no impostor, o impostor ganha a ronda.
- Se um ou mais jogadores acertarem, apenas esses jogadores passam ao minijogo final.
- No minijogo, os jogadores que acertaram tentam adivinhar para onde o impostor vai fugir: esquerda, centro ou direita.
- Se algum deles acertar, mata o impostor e ganha 1 ponto.
- Os restantes jogadores não ganham nada nessa ronda.

O jogo não depende de reflexos, mas sim de bluff, leitura dos outros jogadores e escolhas.

---

## 🔁 Core Gameplay Loop
1. Os jogadores começam o jogo
2. Um jogador é escolhido como impostor
3. Todos recebem uma pergunta
4. Os jogadores respondem, enquanto o impostor tenta fingir
5. Todos votam em quem acham que é o impostor
6. Verifica-se o resultado da votação:
   - Se ninguém acertar, o impostor ganha a ronda
   - Se alguém acertar, esses jogadores passam ao minijogo
7. Minijogo:
   - Os jogadores que acertaram escolhem esquerda, centro ou direita
   - O impostor escolhe para onde fugir
8. Resultado:
   - Se algum jogador escolher a posição certa, mata o impostor e ganha 1 ponto
   - Se ninguém acertar, ninguém ganha pontos
9. Começa a ronda seguinte

---

## 🎮 Player Actions
- Responder à pergunta
- Votar no jogador suspeito
- Escolher uma direção no minijogo
- Tentar prever a fuga do impostor

---

## 📱 UI Screens
- Splash Screen
- Main Menu
- Lobby
- Question Screen
- Voting Screen
- Vote Result Screen
- Minigame Screen
- Round Result Screen
- Winner Screen

---

## ⚙️ Technical Approach (SpriteKit)

### Estrutura
- UIKit para menus, navegação e ecrãs principais
- SpriteKit para o minijogo final

### Componentes principais
- `GameManager` → controla a lógica da ronda, votos, pontuação e transições
- `Player` → guarda nome, pontuação e estado do jogador
- `QuestionManager` → gere as perguntas do jogo
- `VotingManager` → conta votos e identifica quem acertou no impostor
- `MinigameScene` → gere o minijogo de fuga e disparo

### Lógica do minijogo
- O impostor escolhe uma de 3 posições: esquerda, centro ou direita
- Apenas os jogadores que acertaram na votação participam
- Cada um escolhe uma posição para disparar
- Se uma escolha coincidir com a posição do impostor, esse jogador mata o impostor
- O jogador que o matar ganha 1 ponto
- Se ninguém acertar, ninguém ganha pontos

---

## 🚀 MVP Scope

### Inclui
- Jogo local no mesmo dispositivo
- 3 a 5 jogadores
- Seleção aleatória do impostor
- Perguntas fixas
- Sistema de respostas simples
- Sistema de votação
- Minijogo final com 3 escolhas
- Sistema de pontuação por rondas

### Não inclui
- Multiplayer online
- Chat
- Contas de utilizador
- Matchmaking
- Muitos minijogos
- Animações complexas

---

## ⚠️ Feasibility Check

### O que é mais complexo
- Multiplayer online
- Lobby com ligação entre vários telemóveis
- Vários minijogos diferentes
- Sincronização em tempo real entre jogadores

### O que deve ser simplificado
- Fazer o jogo local
- Usar apenas um minijogo
- Usar perguntas fixas
- Fazer uma interface simples

### MVP menor e mais seguro
- 3 jogadores
- 1 pergunta por ronda
- 1 votação
- 1 minijogo
- 1 ponto para quem matar o impostor

---

## ⚠️ Biggest Risk + Mitigation

### Risco
O projeto ficar demasiado grande por tentar incluir multiplayer, lobby real e demasiadas mecânicas.

### Mitigação
Focar apenas no essencial:
- jogo local
- uma ronda simples
- votação
- minijogo final
- pontuação básica

---

## 💡 Future Ideas
- Mais perguntas
- Mais minijogos
- Melhor apresentação visual
- Sons e efeitos
- Mais tipos de pontuação
- Multiplayer online no futuro

---

## ✅ Conclusão
Asmigos é um jogo social simples e realista para desenvolver em Swift com SpriteKit.  
A ideia principal é fácil de perceber, as mecânicas são claras, e o projeto pode ser reduzido a um MVP viável para um trabalho de estudante.
