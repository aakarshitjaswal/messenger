//
//  LoginViewController.swift
//  Messenger
//
//  Created by Aakarshit Jaswal on 22/02/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    //MARK: SubViews

    //creating ScrollView
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    //Creating imageview for logo
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //creating emailTextField
    private let emailTextField: UITextField = {
        let field = UITextField()
        field.contentMode = .center
        field.autocapitalizationType = .none
        field.attributedPlaceholder = NSAttributedString(string:"Email", attributes:[NSAttributedString.Key.foregroundColor: UIColor.darkGray])

        field.textColor = .black
        field.layer.cornerRadius = 10
        field.autocorrectionType = .no
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.returnKeyType = .continue
        field.backgroundColor = UIColor.systemGray5
        return field
    }()
    
    //creating passwordTextField
    private let passwordTextField: UITextField = {
        let field = UITextField()
        field.contentMode = .center
        field.autocapitalizationType = .none
            field.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        field.layer.cornerRadius = 10
        field.autocorrectionType = .no
        field.isSecureTextEntry = true
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.returnKeyType = .done
        field.backgroundColor = UIColor.systemGray5
        field.textColor = .black
        return field
    }()
    
    //Creating Login Button
    private let logInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .link
        button.layer.cornerRadius = 10
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: CGFloat(20))
        button.layer.masksToBounds = true
        
        return button
    }()

    
    
    //MARK: ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Log in"
        view.backgroundColor = .white
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //Creating right bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        //Add target to log in button
        logInButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        
        //Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(logInButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //MARK: SubView Frames

        //Setting the size of the views
        let size = view.width/3
        scrollView.frame = CGRect(x: view.left, y: view.top, width: view.width, height: view.height)
        
        imageView.frame = CGRect(x: size, y: 100, width: size, height: size)
        
        emailTextField.frame = CGRect(x: view.width/7, y: imageView.bottom + 50, width: (view.width/7) * 5, height: 50)
        
        passwordTextField.frame = CGRect(x: emailTextField.left, y: emailTextField.bottom + 5, width: emailTextField.width, height: emailTextField.height)
        
        logInButton.frame = CGRect(x: emailTextField.left, y: passwordTextField.bottom + 20, width: passwordTextField.width, height: passwordTextField.height)
    }
    

    
    //Creating an alert for displaying errors
    func alertUserLogInError() {
        let alert = UIAlertController(title: "Woops!", message: "Please fill in your log in information", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Tap Behaviour

    //Function for register button tap behaviour
    @objc private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //Function for on login button tap behaviour
    @objc private func didTapLogin() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty, password.count > 6 else {
            return
        }
        //Firebase log in
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let result = authResult, error == nil else {
                print("Error occured while logging in")
                return
            }
            let user = result.user
            print(user)
        }
        print("Logged in user")
        
    }
}

//MARK: Extension

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            didTapLogin()
        } 
        
        return true
    }
}
