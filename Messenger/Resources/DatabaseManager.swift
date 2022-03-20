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
    
    //gets safeEmail that can be used as a node name in Firebase
    static func safeEmail(email: String) -> String {
        let replacedEmail = email.replacingOccurrences(of: ".", with: "*")
        return "\(replacedEmail)"
    }
    
}

//MARK: Account Management

extension DatabaseManager {
    //Checks if user on Firebase exists
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
    
    //Insets a new user to Firebase
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
            
            self.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if var userCollection = snapshot.value as? [[String: String]] {
                    //append user
                    let newElement = [
                        "name": user.firstName + user.lastName,
                        "email": user.email
                    ]
                    
                    userCollection.append(newElement)
                    
                    self.database.child("users").setValue(userCollection) { error, _ in
                        completion(true)
                        
                    }
                    
                } else {
                    //create first user array
                    let newCollection: [[String: String]] = [
                        [
                            "name": user.firstName + user.lastName,
                            "email": user.email
                        ]
                    ]
                    
                    self.database.child("users").setValue(newCollection) { error, _ in
                        completion(true)
                        
                    }
                }
            })
        }
    }
    
    //Get all users
    func getAllUsers(withCompletionBlock completion: @escaping (Result<[[String:String]], Error>) -> Void ){
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [[String:String]] else {
                completion(.failure(DatabaseErrors.failedToGetUsers))
                print("Couldn't get all users")
                return
            }
            completion(.success(value))
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
        return "\(safeEmail)_profile_picture.png"
    }
}

enum DatabaseErrors: Error {
    case failedToGetUsers
}
