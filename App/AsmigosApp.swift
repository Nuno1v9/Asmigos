import SwiftUI

@main
struct AsmigosApp: App {
    @StateObject private var vm = GameViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(vm)
                .preferredColorScheme(.dark)
                .tint(Color(red: 0.8, green: 0.1, blue: 0.1))
        }
    }
}
