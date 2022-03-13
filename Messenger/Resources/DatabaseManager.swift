//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Aakarshit Jaswal on 25/02/22.
//

import Foundation
import Firebase
import FirebaseDatabase

class DatabaseManager {
    static let shared = DatabaseManager()
    
    public let database = Database.database().reference()
    
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
    
    
    func insertUser(with user: ChatUser) {
        database.child(user.safeEmail).setValue([
            "firstName":user.firstName,
            "lastName":user.lastName,
            "email":user.email
        ])
    }
}

struct ChatUser {
    var email: String
    var firstName: String
    var lastName: String
    var safeEmail: String {
        return email.replacingOccurrences(of: ".", with: "*")
    }
}
