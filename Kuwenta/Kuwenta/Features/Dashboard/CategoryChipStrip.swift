import SwiftUI

struct CategoryChipStrip: View {
    let items: [DashboardViewModel.CategoryTotal]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Saan ka pinakamadalas gumastos")
                .font(KuwentaTypography.sectionTitle)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(items) { item in
                        CategoryChip(item: item)
                    }
                }
            }
        }
    }
}

private struct CategoryChip: View {
    let item: DashboardViewModel.CategoryTotal

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: item.icon)
                .foregroundStyle(Color(brandAsset: item.colorAsset))
            VStack(alignment: .leading, spacing: 0) {
                Text(item.name)
                    .font(KuwentaTypography.chip)
                Text(item.displayTotal)
                    .font(KuwentaTypography.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(Capsule(style: .continuous))
    }
}
