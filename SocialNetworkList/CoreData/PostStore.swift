//
//  PostStore.swift
//  SocialNetworkList
//
//  Created by Ilya Nikitash on 3/8/25.
//
import Foundation
import CoreData
import UIKit

final class PostStore {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = {
        return CoreDataManager.shared.persistentContainer.viewContext
    }()) {
        self.context = context
    }
    
    func addNew(post: PostModel) throws {
        let postCoreData = Post(context: context)
        postCoreData.id = Int32(post.id ?? 0)
        postCoreData.postName = post.postName
        postCoreData.postText = post.postText
        postCoreData.isLiked = post.isLiked
        do {
            try context.save()
        } catch {
            fatalError("Failed to save post: \(error)")
        }
    }
    
    func fetchAllPosts() -> [PostModel] {
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        do {
            return try context
                .fetch(fetchRequest)
                .compactMap { post -> PostModel? in
                    guard
                          let profileAvatar = post.profileAvatar,
                          let postName = post.postName,
                          let postText = post.postText else { return nil }
                    return PostModel(id: Int(post.id),
                                     profileAvatar: (UIImage(data: profileAvatar) ?? UIImage(named: "StubImage")) ?? UIImage(),
                                     postName: postName,
                                     postText: postText,
                                     isLiked: post.isLiked)
                }
        } catch {
            fatalError("Failed to fetch: \(error.localizedDescription)")
        }
    }
}
