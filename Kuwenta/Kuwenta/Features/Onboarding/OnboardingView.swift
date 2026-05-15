import SwiftUI

struct OnboardingView: View {
    @State private var viewModel = OnboardingViewModel()

    var body: some View {
        VStack(spacing: 24) {
            TabView(selection: Binding(
                get: { viewModel.currentPage },
                set: { viewModel.currentPage = $0 }
            )) {
                WelcomePage().tag(0)
                PrivacyPage().tag(1)
                LaterPermissionsPage().tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            Button(action: handlePrimary) {
                Text(viewModel.isLastPage ? "Tara, simulan na" : "Sige, next")
                    .font(KuwentaTypography.sectionTitle)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(KuwentaColor.primaryPurple)
                    .foregroundStyle(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color(.systemBackground))
    }

    private func handlePrimary() {
        if viewModel.isLastPage {
            viewModel.complete()
        } else {
            viewModel.advance()
        }
    }
}

private struct WelcomePage: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "peacesign")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundStyle(KuwentaColor.primaryPurple)
            Text("Kumusta!")
                .font(KuwentaTypography.displayAmount)
            Text("Pera, pamilya, at tropa — lahat tinotrack.\nWalang sermon, walang shame.")
                .font(KuwentaTypography.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 32)
            Spacer()
        }
    }
}

private struct PrivacyPage: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer(minLength: 24)
            Image(systemName: "lock.shield.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundStyle(KuwentaColor.successGreen)
            Text("Privacy muna, bes.")
                .font(KuwentaTypography.displayAmount)
            VStack(alignment: .leading, spacing: 12) {
                PrivacyBullet(title: "Sa phone mo nakatira", body: "Lahat ng pera mo, sa device mo lang. Hindi kami nagse-send ng SMS o transaction off-device.")
                PrivacyBullet(title: "Walang silent gastos", body: "Kuwenta will never auto-cancel, auto-transfer, o auto-send. Ikaw pa rin ang pipindot.")
                PrivacyBullet(title: "iCloud sync, optional", body: "Kapag in-on mo ang CloudKit sync, encrypted at sa Apple ID mo lang nakaupo.")
            }
            Spacer()
        }
        .padding(.horizontal, 28)
    }
}

private struct LaterPermissionsPage: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer(minLength: 24)
            Image(systemName: "hand.wave.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundStyle(KuwentaColor.accentCoral)
            Text("Hihingin namin mamaya:")
                .font(KuwentaTypography.displayAmount)
            VStack(alignment: .leading, spacing: 12) {
                PrivacyBullet(title: "SMS filter (Phase 2)", body: "Para auto-log ang BDO, GCash, Maya receipts. On-device lang ang parsing.")
                PrivacyBullet(title: "Notifications", body: "Para ma-warn ka kung mag-rerenew na ang Netflix o malapit na ang sahod.")
                PrivacyBullet(title: "Contacts (Phase 5)", body: "Para mas mabilis maghati ng bill sa tropa.")
            }
            Text("Wala muna sa Phase 1 — pwede mo i-skip lahat.")
                .font(KuwentaTypography.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 8)
            Spacer()
        }
        .padding(.horizontal, 28)
    }
}

private struct PrivacyBullet: View {
    let title: String
    let body: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(KuwentaColor.successGreen)
                .font(.title3)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(KuwentaTypography.sectionTitle)
                Text(body)
                    .font(KuwentaTypography.body)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
