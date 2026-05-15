import SwiftUI

struct CategoryPickerView: View {
    let categories: [CategoryRecord]
    @Binding var selection: String?

    private let columns = [
        GridItem(.adaptive(minimum: 96), spacing: 10)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(categories) { category in
                CategoryTile(
                    category: category,
                    isSelected: selection == category.code,
                    onTap: { selection = category.code }
                )
            }
        }
        .padding(.vertical, 4)
    }
}

private struct CategoryTile: View {
    let category: CategoryRecord
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                Image(systemName: category.iconSystemName)
                    .font(.title3)
                    .foregroundStyle(Color(brandAsset: category.colorAssetName))
                Text(category.name)
                    .font(KuwentaTypography.chip)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? Color(brandAsset: category.colorAssetName).opacity(0.18) : Color(.tertiarySystemGroupedBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color(brandAsset: category.colorAssetName) : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}
