//
//  PostStore.swift
//  SocialNetworkList
//
//  Created by Ilya Nikitash on 3/8/25.
//
import Foundation
import CoreData
import UIKit

enum StoreErrors: Error {
    case invalidFetch
}

final class PostStore: NSObject, NSFetchedResultsControllerDelegate {
    private let context: NSManagedObjectContext
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Post> = {
        let fetchResult = Post.fetchRequest()
        fetchResult.sortDescriptors = [NSSortDescriptor(key: "postName", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchResult,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    init(context: NSManagedObjectContext = {
        return CoreDataManager.shared.persistentContainer.viewContext
    }()) {
        self.context = context
    }
    
    func addNew(post: PostModel) {
        let postCoreData = Post(context: context)
        postCoreData.id = post.id
        let imageData = post.profileAvatar?.pngData()
        guard let imageData else { return }
        postCoreData.profileAvatar = imageData
        postCoreData.postName = post.postName
        postCoreData.postText = post.postText
        postCoreData.isLiked = post.isLiked
        do {
            try context.save()
        } catch {
            fatalError("Failed to save post: \(error)")
        }
    }
    
    func delete(post: PostModel) {
        guard let postToDelete = getPostCoreData(by: post.id) else {
            return
        }
        
        context.delete(postToDelete)
        
        do {
            try context.save()
            print("Post deleted")
            try fetchedResultsController.performFetch()
            print("Updated: \(fetchedResultsController.fetchedObjects ?? [])")
        } catch {
            print("Error updating context: \(error.localizedDescription)")
        }
    }
    
    func getPostCoreData(by id: UUID) -> Post? {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(
            format: "id == %@", id as CVarArg
        )
        
        do {
            try fetchedResultsController.performFetch()
            guard let post = fetchedResultsController.fetchedObjects?.first else {
                throw StoreErrors.invalidFetch
            }
            
            fetchedResultsController.fetchRequest.predicate = nil
            return post
        } catch {
            fatalError("Failed to fetch post by UUID: \(error)")
        }
    }
    
    func fetchAllPosts() -> [PostModel] {
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        do {
            return try context
                .fetch(fetchRequest)
                .compactMap { post -> PostModel? in
                    guard
                        let id = post.id,
                        let profileAvatar = post.profileAvatar,
                        let postName = post.postName,
                        let postText = post.postText else { return nil }
                    return PostModel(id: id,
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
