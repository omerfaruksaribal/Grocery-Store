import UIKit
import Combine

final class RegisterViewController: UIViewController {
    //  MARK: - UI
    private let usernameTextField = UITextField()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let button = UIButton(type: .system)
    private let stack = UIStackView()

    private var bag = Set<AnyCancellable>()
    private let vm: RegisterViewModel

    //  MARK: - init
    init(vm: RegisterViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    //  MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Register"

        bind()
        buildUI()
    }

    //  MARK: - actions
    @objc private func didTapRegister() {
        Task {
            await vm.register()
        }
    }

    //  MARK: - binding
    private func bind() {
        usernameTextField.textPublisher.assign(to: &vm.$username)
        emailTextField.textPublisher.assign(to: &vm.$email)
        passwordTextField.textPublisher.assign(to: &vm.$password)

        vm.$errorMessage
            .sink { [weak self] error in
                guard let error else { return }
                self?.showAlert(msg: error)
            }.store(in: &bag)

        vm.$isLoading
            .sink { [weak self] loading in
                self?.button.isEnabled = !loading
            }.store(in: &bag)
    }

    //  MARK: - UI set-up
    private func buildUI() {
        usernameTextField.placeholder = "Username"
        emailTextField.placeholder    = "Email"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true

        [usernameTextField, emailTextField, passwordTextField].forEach {
            $0.borderStyle = .roundedRect
            $0.autocapitalizationType = .none
        }

        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)

        stack.axis  = .vertical
        stack.spacing = 12
        [usernameTextField, emailTextField, passwordTextField, button].forEach { stack.addArrangedSubview($0) }

        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor  )
        ])
    }
}

