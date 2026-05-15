import Foundation
import Observation

@Observable
final class OnboardingViewModel {
    static let completedKey = "ph.kuwenta.onboarding.completed"

    var currentPage: Int = 0
    let totalPages: Int = 3

    var isLastPage: Bool { currentPage == totalPages - 1 }

    func advance() {
        if currentPage < totalPages - 1 {
            currentPage += 1
        }
    }

    func complete() {
        UserDefaults.standard.set(true, forKey: Self.completedKey)
    }
}
