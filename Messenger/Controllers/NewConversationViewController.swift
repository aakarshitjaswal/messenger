//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by Aakarshit Jaswal on 22/02/22.
//

import UIKit

class NewConversationViewController: UIViewController {
    
    var users = [[String:String]]()
    var results = [[String:String]]()
    var hasFetched = false

    
    //MARK: SubViews
    //SearchBar
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search a contact"
        return searchBar
    }()
    
    //tableView to populate users
    private var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
        table.isHidden = true
        return table
    }()
    
    //if no search results
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
        searchBar.delegate = self
        view.backgroundColor = .white
        setupTableView()
        view.addSubview(tableView)

        
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        
        
    }
    
    //Setup tableView
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //ViewDidlayout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        noResultsLabel.frame = view.bounds
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
  

}

extension NewConversationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        cell.textLabel?.textColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //take user to chat
    }
}

extension NewConversationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            print("printing isEmpty")
            return
        }
        print(hasFetched)
        results = [[String:String]]()
        self.searchResults(with: text)
        print(hasFetched)
    }
    
    func searchResults(with querry: String) {
        if hasFetched == true {
            //filter
            filterSearch(with: querry)
        } else {
            //fetch users then filter
            DatabaseManager.shared.getAllUsers { [weak self] result in
                
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let userCollection):
                    self?.users = userCollection
                    self?.hasFetched = true
                    self?.filterSearch(with: querry)
                }
            }
            
        }
    }
    
    func filterSearch(with querry: String) {
        guard hasFetched else {
            print("has fetched is false")
            return
        }
        let results: [[String:String]] = self.users.filter({
            guard let name = $0["name"]?.lowercased() else {
                return false
            }
            
            return name.hasPrefix(querry.lowercased())
        })
        self.results = results
        updateIU()
    }
    
    func updateIU() {
        if results.isEmpty {
            noResultsLabel.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
            noResultsLabel.isHidden = true
            tableView.reloadData()
    }
}
}
