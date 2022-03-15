//
//  ViewController.swift
//  Messenger
//
//  Created by Aakarshit Jaswal on 22/02/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ConversationsViewController: UIViewController {

    
    //MARK: SubViews

    //TableView
    private let conversationTableView: UITableView = {
        var table = UITableView()
        //Keeping the tableView hidden because we want to fetch the conversation from the database, if there are no conversation we are going to show no conversations label instead of a table
        table.isHidden = true
        //Registering the Cell on tableView
        table.register(UITableViewCell.self, forCellReuseIdentifier: "conversationCell")
        return table
    }()
    
    //No conversation Label
    private let noConversationLabel: UILabel = {
        var label = UILabel()
        label.text = "No Conversations!"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.isHidden = true
        return label
    }()

    //MARK: ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        validateAuth()
        
        //Add Subviews
        view.addSubview(conversationTableView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapCompose))
        
        setupTableView()
        fetchConversations()
    }
    
    override func viewDidLayoutSubviews() {
        conversationTableView.frame = view.bounds
       
    }
    
    @objc func didTapCompose() {
        let vc = NewConversationViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    func setupTableView() {
        conversationTableView.delegate = self
        conversationTableView.dataSource = self
    }
    
    func fetchConversations() {
        conversationTableView.isHidden = false
    }
    
    func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        }
    }
}

extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath)
        cell.textLabel?.text = "Hello World"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController()
        vc.title = "Aakarshit Jaswal"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

