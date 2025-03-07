//
//  ViewController.swift
//  SocialNetworkList
//
//  Created by Ilya Nikitash on 3/5/25.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .customWhite
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var posts: [PostModel] = []
    private var avatarLoaderObserver: NSObjectProtocol?
    private var postLoaderObserver: NSObjectProtocol?
    private let postLoader = PostLoader.shared
    private let avatarLoader = AvatarLoader.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPostObserver()
        setupUserInterface()
        setupNavigationBar()
        setupTableView()
        postLoader.fetchPosts()
    }
    
    private func setupAvatarObserver() {
        avatarLoaderObserver = NotificationCenter.default.addObserver(forName: AvatarLoader.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self else { return }
            self.tableView.reloadData()
        }
    }
    
    private func setupPostObserver() {
        postLoaderObserver = NotificationCenter.default
            .addObserver(forName: PostLoader.didChangeNotification,
                         object: nil,
                         queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.posts = postLoader.posts
                self.tableView.reloadData()
            }
    }
    
    private func setupUserInterface() {
        view.backgroundColor = .customWhite
        
        view.addSubview(tableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MSTableViewCell.self, forCellReuseIdentifier: MSTableViewCell.identifier)
    }
}

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

extension MainScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
}
