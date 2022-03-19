//
//  RegisterViewController.swift
//  Messenger
//
//  Created by Aakarshit Jaswal on 22/02/22.
//

import UIKit
import PhotosUI
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
    let spinner = JGProgressHUD(style: .dark)
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
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.systemGray5.cgColor
        imageView.clipsToBounds = true
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
    
    //creating emailTextField
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.attributedPlaceholder = NSAttributedString(string:"First Name", attributes:[NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        field.textColor = .black
        field.layer.cornerRadius = 10
        field.autocorrectionType = .no
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.returnKeyType = .continue
        field.backgroundColor = UIColor.systemGray5
        return field
    }()
    
    //creating emailTextField
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.contentMode = .center
        field.autocapitalizationType = .none
        field.attributedPlaceholder = NSAttributedString(string:"Last Name", attributes:[NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
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
    private let registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: CGFloat(20))
        button.layer.masksToBounds = true
        
        return button
    }()
    
    
    
    //MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Register"
        view.backgroundColor = .white
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        
        imageView.isUserInteractionEnabled = true
        
        //Add target to log in button
        registerButton.addTarget(self, action: #selector(didTapRegisterNewAccount), for: .touchUpInside)
        
        //MARK: Adding Subviews
        
        //Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(registerButton)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        imageView.addGestureRecognizer(gesture)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //MARK: SubView Frames
        
        //Setting the size of the views
        let size = view.width/3
        scrollView.frame = CGRect(x: view.left, y: view.top, width: view.width, height: view.height)
        
        imageView.frame = CGRect(x: size, y: 100, width: size, height: size)
        imageView.layer.cornerRadius = imageView.width/2
        emailTextField.frame = CGRect(x: view.width/7, y: imageView.bottom + 50, width: (view.width/7) * 5, height: 50)
        
        firstNameField.frame = CGRect(x: emailTextField.left, y: emailTextField.bottom + 5, width: emailTextField.width, height: emailTextField.height)
        
        lastNameField.frame = CGRect(x: emailTextField.left, y: firstNameField.bottom + 5, width: emailTextField.width, height: emailTextField.height)
        
        passwordTextField.frame = CGRect(x: emailTextField.left, y: lastNameField.bottom + 5, width: emailTextField.width, height: emailTextField.height)
        
        registerButton.frame = CGRect(x: emailTextField.left, y: passwordTextField.bottom + 20, width: passwordTextField.width, height: passwordTextField.height)
    }
    
    
    
    //Creating an alert for displaying errors
    func alertUserLogInError(message: String) {
        let alert = UIAlertController(title: "Woops!", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Tap Behaviour
    
    //Function for on Register button tap behaviour
    @objc private func didTapRegisterNewAccount() {
        spinner.show(in: view)
        emailTextField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let firstName = firstNameField.text,
              let lastName = lastNameField.text,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              password.count > 6 else {
            print("Register Button Tapped")
            return
        }
        //MARK: Firebase new user

        //Firebase new user registeration
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) {[weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            
            //Loading spinner start
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss(animated: true)
            }
            
            guard authResult !== nil , error == nil else {
                DispatchQueue.main.async {
                    strongSelf.alertUserLogInError(message: error?.localizedDescription ?? "Error occured")
                }
                print("Error occured while creating a new user \(error!)")
                return
            }
            
            //Creating ChatUser object, also to get profile picture filename computed property on it while adding it to Firebase
            let chatUser = ChatUser(email: email, firstName: firstName, lastName: lastName)
            
            //Registering user to Firebase
            DatabaseManager.shared.insertUser(with: chatUser) { success in
                guard success else {
                    print("couldn't add user to firebase")
                    return
                }
                
                guard let image = strongSelf.imageView.image, let data = image.pngData() else {
                    return
                }
                let fileName = chatUser.profilePictureName
                
                //Uploading Profile Picture to Firebase database
                StorageManager.storageManager.uploadProfilePicture(with: data, fileName: fileName) { result in
                    switch result {
                        
                    case .failure(let error):
                        print("\(error)Error occured while uploading image")
                        
                    case.success(let downloadURL):
                        
                        //Storing the picture url in UserDefaults to save Firebase API calls in future
                        UserDefaults.standard.set(downloadURL, forKey: "profile_picture_url")
                        print(downloadURL)
                    }
                }
            }
            //Taking user to Conversation VC
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
     
        

        
        
    }
    
    //Function for on Image tap behaviour
    
    @objc private func didTapImage() {
        presentPhotoActionSheet()
        print("image tapped")
    }
}

//MARK: Extension

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            firstNameField.becomeFirstResponder()
        } else if textField == firstNameField {
            lastNameField.becomeFirstResponder()
        } else if textField == lastNameField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            didTapRegisterNewAccount()
        }
        
        return true
    }
}


//MARK: Present photo picker

extension RegisterViewController: UIImagePickerControllerDelegate ,PHPickerViewControllerDelegate, UINavigationControllerDelegate {
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select the and image?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { [weak self]_ in
            self?.presentPhotoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    func presentPhotoLibrary() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        
        present(vc, animated: true, completion: nil)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
        
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true) {
            guard let result = results.first else {
                print("error occured while selecting a picture")
                return
            }
            
            let prov = result.itemProvider
            guard prov.canLoadObject(ofClass: UIImage.self) else {
                print("error while loading image")
                return
            }
            
            prov.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        imageView.image = selectedImage
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

