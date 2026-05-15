import SwiftUI

struct PeraSaBulsaCard: View {
    let amount: Decimal

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Gastos ngayong buwan")
                .font(KuwentaTypography.caption)
                .foregroundStyle(.white.opacity(0.85))
            Text(CurrencyFormatter.string(from: amount))
                .font(KuwentaTypography.displayAmount)
                .foregroundStyle(.white)
                .contentTransition(.numericText())
            Text("Pera sa bulsa, tinitignan natin")
                .font(KuwentaTypography.caption)
                .foregroundStyle(.white.opacity(0.85))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            LinearGradient(
                colors: [KuwentaColor.primaryPurple, KuwentaColor.primaryPurple.opacity(0.75)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: KuwentaColor.primaryPurple.opacity(0.25), radius: 12, y: 6)
    }
}

#Preview {
    PeraSaBulsaCard(amount: 12_345)
        .padding()
}
