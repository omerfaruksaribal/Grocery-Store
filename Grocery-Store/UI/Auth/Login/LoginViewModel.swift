import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let auth = AuthService()

    func login() async {
        isLoading = true ; defer { isLoading = false }
        let request = LoginRequest(username: username, password: password)
        do {
            let response = try await auth.login(request)
            guard let token = response.data else {
                throw URLError(.badServerResponse)
            }
            TokenStorage.save(token)
            RootNavigator.shared.goToMainApp()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
