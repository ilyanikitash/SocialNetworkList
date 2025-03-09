//
//  SavedPostsViewController.swift
//  SocialNetworkList
//
//  Created by Ilya Nikitash on 3/5/25.
//
import UIKit

final class SavedPostsViewController: UIViewController {
    // MARK: - Properties
    private let savedPostsView = SavedPostsView()
    private let postStore = PostStore()
    private var posts: [PostModel] = []
    // MARK: - Lifecycle
    override func loadView() {
        self.view = savedPostsView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        savedPostsView.configure()
        savedPostsView.savedPostsDelegate = self
        setupTableView()
        getSavedPosts()
    }
    // MARK: - Setup
    private func setupTableView() {
        savedPostsView.tableView.dataSource = self
        savedPostsView.tableView.delegate = self
    }
    // MARK: - Functions
    private func delete(post: PostModel) {
        let alertController = UIAlertController(
            title: "Уверены?",
            message: "Удалить пост из сохраненных?",
            preferredStyle: .actionSheet
        )
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.postStore.delete(post: post)
            self.getSavedPosts()
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel) { [weak self] _ in
            guard let self else { return }
            self.getSavedPosts()
        }
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
// MARK: - UITableViewDelegate
extension SavedPostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let post = posts[indexPath.row]
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: "Удалить") { [weak self] _ in
                    guard let self else { return }
                    self.delete(post: post)
                }
            ])
        })
    }
}
// MARK: - SavedPostsDelegate
extension SavedPostsViewController: SavedPostsDelegate {
    func getSavedPosts() {
        posts = postStore.fetchAllPosts()
        savedPostsView.tableView.reloadData()
    }
}
// MARK: - UITableViewDataSource
extension SavedPostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MSTableViewCell.identifier, for: indexPath) as? MSTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let post = posts[indexPath.row]
        cell.configureSavedPost(with: post)
        return cell
    }
}
