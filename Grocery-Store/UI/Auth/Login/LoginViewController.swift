import UIKit
import Combine

final class LoginViewController: UIViewController {
    private var usernameTextField = UITextField()
    private var passwordTextField = UITextField()
    private var button = UIButton(type: .system)
    private var stack = UIStackView()

    private var bag = Set<AnyCancellable>()
    private var vm: LoginViewModel

    init(vm: LoginViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Login"
        
    }

    @objc private func didTapLogin() {
        Task {
            await vm.login()
        }
    }

    private func bind() {
        usernameTextField.textPublisher.assign(to: &vm.$username)
        passwordTextField.text.publisher.assign(to: &vm.$password)

        vm.$errorMessage
            .sink { [weak self] error in
                guard let error else { return }

            }.store(in: &bag)

        vm.$isLoading
            .sink { [weak self] loading in
                self?.button.isEnabled = !loading
            }.store(in: &bag)
    }

    private func buildUI() {
        usernameTextField.placeholder = "Username"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true

        [usernameTextField, passwordTextField].forEach {
            $0.borderStyle = .roundedRect
            $0.autocapitalizationType = .none
        }

        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)

        stack.axis = .vertical
        stack.spacing = 12
        [usernameTextField, passwordTextField, button].forEach { stack.addArrangedSubview($0) }

        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

    }
}
