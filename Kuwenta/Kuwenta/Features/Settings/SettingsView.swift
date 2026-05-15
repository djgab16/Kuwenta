import SwiftUI

struct SettingsView: View {
    @AppStorage(MonthHelpers.monthStartDayKey) private var monthStartDay: Int = 1
    @AppStorage("ph.kuwenta.settings.cloudSyncEnabled") private var cloudSyncEnabled = false
    @AppStorage(OnboardingViewModel.completedKey) private var hasOnboarded = true

    var body: some View {
        Form {
            Section("Pera") {
                LabeledContent("Currency", value: "Philippine Peso (₱)")
                Stepper(value: $monthStartDay, in: 1...28) {
                    LabeledContent("Simula ng buwan", value: "Day \(monthStartDay)")
                }
            }

            Section {
                Toggle(isOn: $cloudSyncEnabled) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("iCloud sync")
                        Text("Encrypted, sa Apple ID mo lang. Buksan kapag handa ka.")
                            .font(KuwentaTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .disabled(!PersistentCloudKitController.cloudKitEnabled)
                if !PersistentCloudKitController.cloudKitEnabled {
                    Text("Bukas pa lang sa Phase 1 ang local storage. I-on ang CloudKit capability sa Xcode bago gamitin.")
                        .font(KuwentaTypography.caption)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("Sync")
            }

            Section("Privacy") {
                Label("Wala pa kaming hinihinging permission ngayon.", systemImage: "lock.shield.fill")
                    .font(KuwentaTypography.body)
                NavigationLink("I-replay ang welcome") {
                    OnboardingView()
                        .onDisappear { hasOnboarded = true }
                }
            }

            Section("Tungkol sa Kuwenta") {
                LabeledContent("Version", value: appVersion)
                Link("developer.apple.com", destination: URL(string: "https://developer.apple.com")!)
            }
        }
        .navigationTitle("Settings")
    }

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.1"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
