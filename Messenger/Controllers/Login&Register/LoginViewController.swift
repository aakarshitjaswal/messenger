//
//  LoginViewController.swift
//  Messenger
//
//  Created by Aakarshit Jaswal on 22/02/22.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import JGProgressHUD

class LoginViewController: UIViewController {
    
    //Creating JGProgress spinner
    let spinner = JGProgressHUD(style: .dark)
    
    var email = ""
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
    //Facebook Login Button
    let facebookLoginButton: FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["public_profile", "email"]
        return button
    }()
    
    //Google Signin Button
    let googleSignInButton: GIDSignInButton = {
        let button = GIDSignInButton()
        return button
    }()
    
    
    
    
    //MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log in"
        facebookLoginButton.delegate = self
        view.backgroundColor = .white
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //Creating right bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        //Add target to log in button
        logInButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        googleSignInButton.addTarget(self, action: #selector(didSigninWithGoogle), for: .touchUpInside)
        
        //Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(logInButton)
        scrollView.addSubview(facebookLoginButton)
        scrollView.addSubview(googleSignInButton)
        
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
        
        facebookLoginButton.frame = CGRect(x: emailTextField.left, y: logInButton.bottom + 20, width: passwordTextField.width, height: passwordTextField.height)
        
        googleSignInButton.frame = CGRect(x: emailTextField.left, y: facebookLoginButton.bottom + 20, width: passwordTextField.width, height: passwordTextField.height)
    }
    
    
    
    //Creating an alert for displaying errors
    func alertUserLogInError(message: String) {
        let alert = UIAlertController(title: "Woops!", message: message, preferredStyle: .alert)
        
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
        if emailTextField.text == "" && passwordTextField.text == "" {
            alertUserLogInError(message: "Enter the dragon!!")
            return
        }
        //Show spinner
        spinner.show(in: view)
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty, password.count > 6 else {
            return
        }
        
        //MARK: Firebase Log in
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) {[weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss(animated: true)
            }
            
            guard let result = authResult, error == nil else {
                
                strongSelf.alertUserLogInError(message: "Couldn't Log in, Please check your credentials")
                
                print("Error occured while logging in")
                return
            }
            
            UserDefaults.standard.set(email, forKey: "email")
            let user = result.user
            print(user)
            
            strongSelf.email = email
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            
        }
        print("Logged in user")
        
    }
    
    //MARK: Google Sign in
    
    @objc private func didSigninWithGoogle() {
        
        spinner.show(in: view)
        
        //Google sign in api returning user in completion
        GIDSignIn.sharedInstance.signIn(with: DatabaseManager.shared.signInConfig, presenting: self) { [weak self] user, error in
            
            guard let strongSelf = self else { return }
            
            guard error == nil else {
                
                DispatchQueue.main.async {
                    strongSelf.spinner.dismiss(animated: true)
                }
                
                strongSelf.alertUserLogInError(message: "Couldn't log in")
                return }
            
            guard let user = user else { return }
            
            guard let email = user.profile?.email, let firstName = user.profile?.givenName, let lastName = user.profile?.familyName else { return }
            
            //Caching email address
            UserDefaults.standard.set(email, forKey: "email")
            
            let auth = user.authentication
            guard let idToken = auth.idToken else {return}
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: auth.accessToken)
            
            //Checking if user exists on firebase database
            DatabaseManager.shared.userExists(with: email) { exists in
                
                guard exists else {
                    //MARK: User Doesn't Exist
    
                    let chatUser = ChatUser(email: email, firstName: firstName, lastName: lastName)
                    
                    //Adding user to firebase
                    DatabaseManager.shared.insertUser(with: chatUser) { success in
                        
                        guard success else {
                            return
                        }
                        
                       
                        //Checking if user has profile image
                        if user.profile?.hasImage == true {
                            guard let url = user.profile?.imageURL(withDimension: 200) else {
                                print("Cannot get google profile image url")
                                return
                            }
                            print(url)
                            
                            //Downloading image
                            URLSession.shared.dataTask(with: url) { data, _, error in
                                guard let safeData = data else {
                                    print("Couldn't fetch google profile image data")
                                    return
                                }
                                let fileName = chatUser.profilePictureName
                                
                                //Uploading Profile Picture to Firebase database
                                StorageManager.storageManager.uploadProfilePicture(with: safeData, fileName: fileName) { result in
                                    switch result {
                                        
                                    case .failure(let error):
                                        print("\(error)Error occured while uploading image")
                                        
                                    case.success(let downloadURL):
                                        
                                        //Storing the picture url in UserDefaults to save Firebase API calls in future
                                        UserDefaults.standard.set(downloadURL, forKey: "profile_picture_url")
                                        print(downloadURL)
                                    }
                                }
                            }.resume()
                        }
                        
                        //Signing using google credentials
                        FirebaseAuth.Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                            guard let strongSelf = self else { return }
                            guard authResult != nil, error == nil else {
                                print("Firebase sign in failed")
                                return
                            }
                            DispatchQueue.main.async {
                                strongSelf.spinner.dismiss(animated: true)
                            }
                            
                            //Successfully LOGGED IN, taking user to conversation VC
                            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                        }
                    }
                    return
                }
                //MARK: User Exists
                
                FirebaseAuth.Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                    guard let strongSelf = self else { return }
                    guard authResult != nil, error == nil else {
                        print("Firebase sign in failed")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        strongSelf.spinner.dismiss(animated: true)
                    }
                    UserDefaults.standard.set(email, forKey: "email")

                    // If sign in succeeded, display the app's main content View
                    strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

//MARK: Extension
//Textfield delegate
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


//MARK: Facebook Login
//Conforming our VC to LoginButtonDelegate from FBSDkLoginKit to implement the delegate functions
extension LoginViewController: LoginButtonDelegate {
    
    //loginButton func from the FBSDK Login Kit
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
//        spinner.show(in: view)
        
        
        
        //Get auth token from result
        guard let token = result?.token?.tokenString else {
            print("Failed to fetch facebook log in token")
            return
        }
        
        //Create graph request
        let facebookRequest = GraphRequest(graphPath: "me", parameters: ["fields":"email, first_name, last_name, picture"], tokenString: token, version: nil, httpMethod: .get)
        
        //Send graph request
        facebookRequest.start { _, result, error in
            
            guard let safeResult = result as? [String: Any], error == nil else {
                print("Failed to make facebook graph request \(String(describing: error))")
                return
            }
            
            print(safeResult)
            
            //Tapping into downcasted result's "firstName" & "email", And downcasting on key at a time on picture key to get the picture url key availabe because of the parameter passed into the Graph API
            guard let firstName = safeResult["first_name"] as? String ,let lastName = safeResult["last_name"] as? String, let email = safeResult["email"] as? String, let picture = safeResult["picture"] as? [String: Any], let data = picture["data"] as?[String: Any], let pictureUrl = data["url"] as? String else {
                print("Failed to get username and email")
                return
            }
            
            //Caching email address
            UserDefaults.standard.set(email, forKey: "email")
        
            //Checking if user exists on Firebase already
            DatabaseManager.shared.userExists(with: email) { exists in
                
                guard exists else {
                    //MARK: User Doesn't Exist
                    //Insert new user
                    let chatUser = ChatUser(email: email, firstName: firstName, lastName: lastName)
                    DatabaseManager.shared.insertUser(with: chatUser ) { success in
                        
                        guard success else {
                            print("Couldn't inser user to database")
                            return
                        }
                        
                        guard let url = URL(string: pictureUrl) else {
                            print("couldn't get picture url")
                            return
                        }
                        
                        //Downloading the image
                        URLSession.shared.dataTask(with: url) { data, _, error in
                            guard let data = data else {
                                print("error fetching facebook profile pic data")
                                return
                            }
                            
                            let fileName = chatUser.profilePictureName
                            
                            //Uploading Facebook Profile Picture to Firebase database
                            StorageManager.storageManager.uploadProfilePicture(with: data, fileName: fileName) { result in
                                switch result {
                                    
                                case .failure(let error):
                                    print("\(error)Error occured while uploading image")
                                    
                                case.success(let downloadURL):
                                    
                                    //Cache picture url to save Firebase API Calls later
                                    UserDefaults.standard.set(downloadURL, forKey: "facebook_profile_picture_url")
                                    print(downloadURL)
                                }
                            }
                        }.resume()
                        
                        //Get facebook auth credentials
                        let credential = FacebookAuthProvider.credential(withAccessToken: token)
                        
                        //Adding Facebook Authentication and signing in using facebook Credentials
                        FirebaseAuth.Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                            
                            guard let strongSelf = self else {
                                return
                            }
                            
                            guard authResult != nil, error == nil else {
                                if let error = error {
                                    print("Failed to sign in using Facebook Credential, \(error)")
                                }
                                return
                            }
                            
                            //User signed in to the app, dismissing the spinner
                            DispatchQueue.main.async {
                                strongSelf.spinner.dismiss(animated: true)
                            }
                            
                            //Taking user to the app
                            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                        }
                    }
                    return
                }
                
                //MARK: User Exists
                //Get Facebook auth credentials
                let credential = FacebookAuthProvider.credential(withAccessToken: token)
                
                //Sign in with credentials
                FirebaseAuth.Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                    
                    guard let strongSelf = self else {
                        return
                    }
                    
                    guard authResult != nil, error == nil else {
                        if let error = error {
                            print("Failed to sign in using Facebook Credential, MFA might be required \(error)")
                        }
                        return
                    }
                    
                    //User signed in to the app, dismissing the spinner
                    DispatchQueue.main.async {
                        strongSelf.spinner.dismiss(animated: true)
                    }
                    //Successfully LOGGED IN, Taking user to the app
                    strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //Not required in this app
        print("Logged out")
    }
}
