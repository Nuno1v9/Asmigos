import SwiftUI

struct RootView: View {
    @EnvironmentObject var vm: GameViewModel

    var body: some View {
        Group {
            switch vm.screen {
            case .splash:
                SplashView()
            case .menu:
                MenuView()
            case .lobby:
                LobbyView()
            case .question:
                QuestionView()
                    .id(vm.roundID)
            case .voting:
                VotingView()
                    .id(vm.roundID)
            case .voteResult:
                VoteResultView()
                    .id(vm.roundID)
            case .impostorChoice:
                ImpostorChoiceView()
                    .id(vm.roundID)
            case .minigame:
                MinigameView()
                    .id(vm.roundID)
            case .roundResult:
                RoundResultView()
                    .id(vm.roundID)
            case .winner:
                WinnerView()
            case .minigamesMenu:
                MinigamesMenuView()
            case .bonusMinigame:
                BonusMinigameView()
                    .id(vm.roundID)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .animation(.easeInOut(duration: 0.25), value: vm.screen)
    }
}
