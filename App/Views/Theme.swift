import SwiftUI

enum AsmigosTheme {
    static let bgTop = Color(red: 0.06, green: 0.0, blue: 0.0)
    static let bgBottom = Color.black
    static let accent = Color(red: 0.78, green: 0.07, blue: 0.09)
    static let panel = Color(red: 0.08, green: 0.08, blue: 0.08)
    static let lightText = Color(red: 0.93, green: 0.93, blue: 0.93)
}

struct AsmigosBackground: View {
    var body: some View {
        LinearGradient(
            colors: [AsmigosTheme.bgTop, AsmigosTheme.bgBottom],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title.uppercased())
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AsmigosTheme.accent)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
