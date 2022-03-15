//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by Aakarshit Jaswal on 22/02/22.
//

import UIKit

class NewConversationViewController: UIViewController {
    
    //MARK: SubViews
    
    //SearchBar
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search a contact"
        return searchBar
    }()
    
    private var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        table.isHidden = true
        return table
    }()
    
    private var noResultsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No matching results"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        view.addSubview(tableView)

        
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        
        
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    @objc func dismissSelf() {

        dismiss(animated: true, completion: nil)
    }
    

}

extension NewConversationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        cell.textLabel?.text = "Hello world"
        cell.textLabel?.textColor = .gray
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
