//
//  SignupVC.swift
//  MDB Social
//
//  Created by Angeline Lee on 29/10/21.
//

import UIKit
import Firebase
import NotificationBannerSwift

class SignupVC: UIViewController {
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 25

        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Sign Up"
        lbl.textColor = .primaryText
        lbl.font = .systemFont(ofSize: 30, weight: .semibold)
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    //email
    private let emailTextField: AuthTextField = {
        let tf = AuthTextField(title: "Email:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    //full name
    private let fullNameTextField: AuthTextField = {
        let tf = AuthTextField(title: "Full Name:")

        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    //username
    private let usernameTextField: AuthTextField = {
        let tf = AuthTextField(title: "Username:")

        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    //password
    private let passwordTextField: AuthTextField = {
        let tf = AuthTextField(title: "Password:")
        tf.textField.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    //second password
    private let secondPasswordTextField: AuthTextField = {
        let tf = AuthTextField(title: "Retype Password:")
        tf.textField.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    // need full name, email, username and password + second password
    //need sign up button
    private let signupButton: LoadingButton = {
        let btn = LoadingButton()
        btn.layer.backgroundColor = UIColor.primary.cgColor
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        btn.isUserInteractionEnabled = true
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let contentEdgeInset = UIEdgeInsets(top: 20, left: 40, bottom: 30, right: 40)
    
    private let signinButtonHeight: CGFloat = 44.0

    private var bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1)
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: contentEdgeInset.top),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: contentEdgeInset.left),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: contentEdgeInset.right)
        ])
        
        stack.addArrangedSubview(emailTextField)
        stack.addArrangedSubview(fullNameTextField)
        stack.addArrangedSubview(usernameTextField)
        stack.addArrangedSubview(passwordTextField)
        stack.addArrangedSubview(secondPasswordTextField)
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: contentEdgeInset.left),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                            constant: -contentEdgeInset.right),
            stack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        ])
        
        view.addSubview(signupButton)

        NSLayoutConstraint.activate([
            signupButton.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            signupButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 30),
            signupButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            signupButton.heightAnchor.constraint(equalToConstant: signinButtonHeight)
        ])
        
        signupButton.layer.cornerRadius = signinButtonHeight / 2
        
        signupButton.addTarget(self, action: #selector(didTapSignUp(_:)), for: .touchUpInside)
    }
    
    @objc func didTapSignUp(_ sender: UIButton) {
        //missing input errors
        guard let email = emailTextField.text, email != "" else {
            showErrorBanner(withTitle: "Missing email", subtitle: "Please provide an email")
            return
        }
        
        guard let password = passwordTextField.text, password != "" else {
            showErrorBanner(withTitle: "Missing password", subtitle: "Please provide a password")
            return
        }
        
        guard let fullName = fullNameTextField.text, fullName != "" else {
            showErrorBanner(withTitle: "Missing name", subtitle: "Please provide a name")
            return
        }
        
        guard let username = usernameTextField.text, username != "" else {
            showErrorBanner(withTitle: "Missing username", subtitle: "Please provide a username")
            return
        }
        
        guard let secondPassword = secondPasswordTextField.text, secondPassword != "" else {
            showErrorBanner(withTitle: "Missing retyped password", subtitle: "Please retype password")
            return
        }
        
        signupButton.showLoading()
        
        SOCAuthManager.shared.signup(givenName: fullName, givenEmail: email, givenUsername: username, givenPassword: password, secondPassword: secondPassword) {
            [weak self] result in
            guard let self = self else { return }
            
            defer {
                self.signupButton.hideLoading()
            }
            
            switch result {
            case .success(let _):
                let vc = FeedVC()
                //var currentEvents = FIRDatabaseRequest.shared.getEvents()
                //vc.events = currentEvents
                let nVC = FeedNavigationVC(rootViewController: vc)
                nVC.modalPresentationStyle = .fullScreen
                self.present(nVC, animated: true, completion: nil)
            case .failure(let error):
                switch error {
                case .missingInput:
                    self.showErrorBanner(withTitle: "Missing input", subtitle: "Please fill in all fields")
                case .passwordsMismatch:
                    self.showErrorBanner(withTitle: "Passwords mismatched", subtitle: "Please retype passwords")
                case .weakPassword:
                    self.showErrorBanner(withTitle: "Weak password", subtitle: "Please use a strong password")
                case .emailInUse:
                    self.showErrorBanner(withTitle: "Email in use", subtitle: "Please use another email")
                case .unspecified:
                    self.showErrorBanner(withTitle: "User not found", subtitle: "Please provide an email")
                case .userNotFound:
                    self.showErrorBanner(withTitle: "User not found", subtitle: "Please provide an email")
                case .wrongPassword:
                    self.showErrorBanner(withTitle: "Wrong password", subtitle: "Please retype password")
                case .internalError:
                    self.showErrorBanner(withTitle: "Internal error", subtitle: "Please reload application")
                case .invalidEmail:
                    self.showErrorBanner(withTitle: "Invalid email", subtitle: "Please retype email")
                case .errorFetchingUserDoc:
                    self.showErrorBanner(withTitle: "Error fetching user information", subtitle: "Please reload application")
                case .errorDecodingUserDoc:
                    self.showErrorBanner(withTitle: "Error loading user information", subtitle: "Please reload application")
                    
                }
            }
        }
    }
    
    private func showErrorBanner(withTitle title: String, subtitle: String? = nil) {
        guard bannerQueue.numberOfBanners == 0 else { return }
        let banner = FloatingNotificationBanner(title: title, subtitle: subtitle,
                                                titleFont: .systemFont(ofSize: 17, weight: .medium),
                                                subtitleFont: subtitle != nil ?
                                                    .systemFont(ofSize: 14, weight: .regular) : nil,
                                                style: .warning)
        
        banner.show(bannerPosition: .top,
                    queue: bannerQueue,
                    edgeInsets: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15),
                    cornerRadius: 10,
                    shadowColor: .primaryText,
                    shadowOpacity: 0.3,
                    shadowBlurRadius: 10)
    }
}
