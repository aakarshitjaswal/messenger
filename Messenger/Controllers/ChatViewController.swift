//
//  ViewController.swift
//  Messenger
//
//  Created by Aakarshit Jaswal on 14/03/22.
//

import UIKit
import MessageKit
import JGProgressHUD

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    let photoURL: String
    let senderId: String
    let displayName: String
}

class ChatViewController: MessagesViewController {
    
    let selfSender = Sender(photoURL: "", senderId: "1", displayName: "Stevenson")
    var messages: [MessageType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messages.append(Message(sender: selfSender, messageId: "Hello", sentDate: Date(), kind: .text("Hello what's up?")))
        messages.append(Message(sender: selfSender, messageId: "yolo", sentDate: Date(), kind: .text("Dude are you even awayer of anything?")))
        messages.append(Message(sender: selfSender, messageId: "bolo", sentDate: Date(), kind: .text("Shit is getting deep yogotta do something about it")))

        
    }
}

extension ChatViewController: MessagesDataSource, MessagesDisplayDelegate, MessagesLayoutDelegate {
    
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
}
