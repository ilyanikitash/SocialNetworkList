//
//  ViewController.swift
//  SocialNetworkList
//
//  Created by Ilya Nikitash on 3/5/25.
//

import UIKit

class MainScreenViewController: UIViewController {
    var posts: [PostModel] = []
    private var avatarLoaderObserver: NSObjectProtocol?
    private var postLoaderObserver: NSObjectProtocol?
    private let postLoader = PostLoader.shared
    private let avatarLoader = AvatarLoader.shared
    private let mainScreenView = MainScreenView()
    //MARK: - Lifecycle
    override func loadView() {
        self.view = mainScreenView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mainScreenView.configure()
        setupPostObserver()
        setupNavigationBar()
        setupTableView()
        postLoader.fetchPosts()
    }
    //MARK: - Setup
    private func setupPostObserver() {
        postLoaderObserver = NotificationCenter.default
            .addObserver(forName: PostLoader.didChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.posts = postLoader.posts
                mainScreenView.tableView.reloadData()
            }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .customWhite
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Лента"
        navigationItem.titleView?.tintColor = .customBlack
        navigationItem.largeTitleDisplayMode = .always
        definesPresentationContext = true
    }
    
    private func setupTableView() {
        mainScreenView.tableView.dataSource = self
        mainScreenView.tableView.delegate = self
    }
}
//MARK: - UITableViewDataSource
extension MainScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MSTableViewCell.identifier, for: indexPath) as? MSTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let post = posts[indexPath.row]
        cell.configure(with: post)
        return cell
    }
}
//MARK: - UITableViewDelegate
extension MainScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
}
