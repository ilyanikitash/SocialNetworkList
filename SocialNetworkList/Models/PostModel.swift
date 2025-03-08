//
//  PostModel.swift
//  SocialNetworkList
//
//  Created by Ilya Nikitash on 3/5/25.
//
import UIKit

struct PostModel {
    let id: Int?
    let profileAvatar: UIImage?
    let postName: String
    let postText: String
    let isLiked: Bool
    
    init(id: Int, profileAvatar: UIImage, postName: String, postText: String, isLiked: Bool) {
        self.id = id
        self.profileAvatar = profileAvatar
        self.postName = postName
        self.postText = postText
        self.isLiked = isLiked
    }
    
    init?(from post: Post) {
        guard
            let profileAvatar = post.profileAvatar,
            let postName = post.postName,
            let postText = post.postText
        else {
            return nil
        }
        
        self.id = Int(post.id)
        self.postName = postName
        self.postText = postText
        self.profileAvatar = UIImage(data: profileAvatar)
        self.isLiked = post.isLiked
    }
    
    init(result post: PostResult) {
        self.id = post.id
        self.postName = post.title
        self.postText = post.body
        self.profileAvatar = UIImage(named: "mockAvatar1")
        self.isLiked = false
    }
    
}

struct PostResult: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
