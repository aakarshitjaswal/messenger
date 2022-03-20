//
//  ProfileViewViewController.swift
//  Messenger
//
//  Created by Aakarshit Jaswal on 22/02/22.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn

class ProfileViewViewController: UIViewController {
    
    
    @IBOutlet var tableView: UITableView!
    
    
    let data = ["Log out"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createHeaderView()

        // Do any additional setup after loading the view.
    }
    
    func createHeaderView() -> UIView? {
        guard let email = UserDefaults.standard.string(forKey: "email") else {
            return nil
        }
        let safeEmail = DatabaseManager.safeEmail(email: email)
        let fileName = "\(safeEmail)" + "_profile_picture.png"
        print(safeEmail)
        let path = "image/" + fileName
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 300))
        let imageView = UIImageView(frame: CGRect(x: (headerView.width - 150) / 2, y: 75 , width: 150, height: 150))
        headerView.backgroundColor = .link
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.cornerRadius = imageView.width / 2
        imageView.layer.masksToBounds = true
        headerView.addSubview(imageView)
        
        StorageManager.storageManager.downloadURL(for: path) { result in
            switch result {
            case .success(let url):
                StorageManager.storageManager.downloadImage(imageView: imageView, url: url)
            case .failure(let error):
                print("failed to get download URL \(error)")
            }
        }
        
        return headerView
    }
}

extension ProfileViewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
        cell.textLabel?.text = data[0]
        cell.textLabel?.textColor = .red
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alert = UIAlertController(title: "Log out", message: "Do you want to Log out?", preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "Log out", style: .destructive) { [weak self] action in
            guard let strongSelf = self else {
                return
            }
            do {
                
                //Facebook sign out
                LoginManager().logOut()
                
                //Google sign out
                GIDSignIn.sharedInstance.signOut()

                //Sign out of logged in user
                try FirebaseAuth.Auth.auth().signOut()
                
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav, animated: true, completion: nil)
                
            } catch {
                print("Error occured while logging out")
            }
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        

    }
}


