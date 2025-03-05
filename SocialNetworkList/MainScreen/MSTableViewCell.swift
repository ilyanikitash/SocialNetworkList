//
//  MSTableViewCell.swift
//  SocialNetworkList
//
//  Created by Ilya Nikitash on 3/5/25.
//
import UIKit

final class MSTableViewCell: UITableViewCell {
    private lazy var cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .post
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var profileAvatar: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mockAvatar1")
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var postName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .customBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var postText: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .customBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ActiveLike"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    static let identifier = "MSTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cellView)
        cellView.addSubview(profileAvatar)
        cellView.addSubview(likeButton)
        cellView.addSubview(postName)
        cellView.addSubview(postText)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            profileAvatar.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 5),
            profileAvatar.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 5),
            profileAvatar.heightAnchor.constraint(equalToConstant: 50),
            profileAvatar.widthAnchor.constraint(equalToConstant: 50),
            
            likeButton.centerYAnchor.constraint(equalTo: profileAvatar.centerYAnchor),
            likeButton.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10),
            likeButton.heightAnchor.constraint(equalToConstant: 24),
            likeButton.widthAnchor.constraint(equalToConstant: 24),
            
            postName.leadingAnchor.constraint(equalTo: profileAvatar.trailingAnchor, constant: 8),
            postName.centerYAnchor.constraint(equalTo: profileAvatar.centerYAnchor),
            
            postText.leadingAnchor.constraint(equalTo: postName.leadingAnchor),
            postText.topAnchor.constraint(equalTo: postName.bottomAnchor, constant: 20)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with post: PostModel) {
//        self.profileAvatar = post.profileAvatar
//        self.postName = post.postName
//        self.postText = post.postText
        profileAvatar.image = post.profileAvatar
        postName.text = post.postName
        postText.text = post.postText
    }
}
