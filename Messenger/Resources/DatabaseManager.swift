//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Aakarshit Jaswal on 25/02/22.
//

import Foundation
import Firebase
import FirebaseDatabase
import GoogleSignIn

class DatabaseManager {
    static let shared = DatabaseManager()
    
    public let database = Database.database().reference()
    
    //Google Sign In configuration
    let signInConfig = GIDConfiguration.init(clientID: "686138751307-4l72ruu3ccu60vmojkh7mrmgdjd3p172.apps.googleusercontent.com")

    
}

//MARK: Account Management

extension DatabaseManager {
    
    func userExists(with email: String, completion: @escaping  ((Bool) -> Void)) {
        let safeEmail = email.replacingOccurrences(of: ".", with: "*")
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    
    func insertUser(with user: ChatUser, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "firstName":user.firstName,
            "lastName":user.lastName,
            "email":user.email
        ]) { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
}

struct ChatUser {
    var email: String
    var firstName: String
    var lastName: String
    var safeEmail: String {
        return email.replacingOccurrences(of: ".", with: "*")
    }
    var profilePictureName: String {
        return "\(safeEmail)_profile_picture"
    }
}
