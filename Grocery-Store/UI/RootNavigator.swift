import UIKit

@MainActor
final class RootNavigator {
    static let shared = RootNavigator()
    private init() {}

    private var window: UIWindow!

    func start(in window: UIWindow) {
        self.window = window
        window.rootViewController = nav(RegisterViewController(vm: .init()))
        window.makeKeyAndVisible()
    }

    func goToLogin() {
        replaceRoot(with: LoginViewController(vm: .init()))
    }
    func goToMainApp() {
        replaceRoot(with: MainViewController())
    }

    // MARK: – helper
    private func nav(_ vc: UIViewController) -> UINavigationController {
        .init(rootViewController: vc)
    }
    private func replaceRoot(with vc: UIViewController) {
        UIView.animate(withDuration: 0.25) {
            self.window.rootViewController = self.nav(vc)
        }
    }
}
