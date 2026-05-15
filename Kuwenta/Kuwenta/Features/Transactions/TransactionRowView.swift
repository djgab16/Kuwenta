import SwiftUI

struct TransactionRowView: View {
    let transaction: TransactionRecord

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color(brandAsset: transaction.categoryColorAsset).opacity(0.15))
                    .frame(width: 40, height: 40)
                Image(systemName: transaction.categoryIcon)
                    .foregroundStyle(Color(brandAsset: transaction.categoryColorAsset))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.note?.isEmpty == false ? transaction.note! : transaction.categoryName)
                    .font(KuwentaTypography.body)
                    .lineLimit(1)
                Text("\(transaction.categoryName) · \(transaction.occurredAt.formatted(date: .abbreviated, time: .shortened))")
                    .font(KuwentaTypography.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(CurrencyFormatter.string(from: transaction.amount))
                .font(KuwentaTypography.body.monospacedDigit())
                .foregroundStyle(.primary)
        }
    }
}
