//
//  HomeViewController.swift
//  PlatziTweets
//
//  Created by Resonant Sports on 18/02/2021.
//

import UIKit
import Simple_Networking
import SVProgressHUD
import NotificationBannerSwift

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newTweet: UIButton!
    
    private let cellId = "TweetTableViewCell"
    private var dataSource = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getPost()
    }

    private func setupUI() {
        newTweet.layer.cornerRadius = 25
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    private func getPost() {
        SVProgressHUD.show()
        
        SN.get(endpoint: Endpoints.getPosts) { ( result: SNResultWithEntity<[Post], ErrorResponse>) in
        
            switch result {
                case .success(let posts):
                    self.dataSource = posts
                    self.tableView.reloadData()
                    
                case .errorResult(let entity):
                    NotificationBanner(title: "Error", subtitle: entity.error, style: .warning).show()
                    
                case .error(let error):
                    NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
            }
            
            SVProgressHUD.dismiss()
        }
    }
    
    
    private func deleteTweetAt(indexPath: IndexPath) {
        SVProgressHUD.show()
        let postId = dataSource[indexPath.row].id
        
        SN.delete(endpoint: Endpoints.delete + postId) { ( result: SNResultWithEntity<GeneralResponse, ErrorResponse>) in
        
            switch result {
                case .success:
                    // 1 borrar tweet del datasource
                    self.dataSource.remove(at: indexPath.row)
                   
                    // 2 borrar celda
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    
                case .errorResult(let entity):
                    NotificationBanner(title: "Error", subtitle: entity.error, style: .warning).show()
                    
                case .error(let error):
                    NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
            }
            
            SVProgressHUD.dismiss()
        }
        
    }
   
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Borrar") { (_, _) in
            self.deleteTweetAt(indexPath: indexPath)
        }
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return dataSource[indexPath.row].author.email == UserDefaults.standard.string(forKey: "email")
    }
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        if let cell = cell as? TweetTableViewCell {
            cell.setupCell(post: dataSource[indexPath.row])
        }
        
        return cell
    }
    
}
