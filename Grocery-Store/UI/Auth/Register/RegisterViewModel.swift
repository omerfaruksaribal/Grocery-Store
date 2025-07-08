import Foundation

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""

    @Published var isLoading = false
    @Published var errorMessage: String?

    private let auth = AuthService()

    func register() async {
            isLoading = true; defer { isLoading = false }
            let req = RegisterRequest(username: username, email: email, password: password)

            do {
                let res = try await auth.register(req)
                guard res.status == 200 else { throw URLError(.badServerResponse) }
                RootNavigator.shared.goToLogin()
            } catch {
                errorMessage = error.localizedDescription
            }
        }

}
