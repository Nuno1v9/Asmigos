import SwiftUI

struct RootView: View {
    @StateObject private var vm = GameViewModel()

    var body: some View {
        switch vm.phase {
        case .splash:
            SplashView()
        case .menu:
            MenuView(vm: vm)
        case .createLobby:
            LobbyEntryView(vm: vm, isCreate: true)
        case .joinLobby:
            LobbyEntryView(vm: vm, isCreate: false)
        case .lobby:
            LobbyView(vm: vm)
        case .question:
            QuestionView(vm: vm)
        case .voting:
            VotingView(vm: vm)
        case .reveal:
            RevealView(vm: vm)
        case .minigame:
            MinigameView(vm: vm)
        case .winner:
            WinnerView(vm: vm)
        }
    }
}
