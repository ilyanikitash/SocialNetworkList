//
//  MainScreenView.swift
//  SocialNetworkList
//
//  Created by Ilya Nikitash on 3/9/25.
//
import UIKit

final class MainScreenView: UIView {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .customWhite
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private var refreshControl = UIRefreshControl()
    @objc private func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            [weak self] in
            guard let self else { return }
            // Обновление таблицы
            self.tableView.reloadData()
            // Остановка анимации
            self.refreshControl.endRefreshing()
        }
    }
    func configure() {
        backgroundColor = .customWhite
        tableView.register(MSTableViewCell.self, forCellReuseIdentifier: MSTableViewCell.identifier)
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.separatorStyle = .none
    }
}


