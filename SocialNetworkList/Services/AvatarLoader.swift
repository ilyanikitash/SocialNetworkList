//
//  AvatarLoader.swift
//  SocialNetworkList
//
//  Created by Ilya Nikitash on 3/6/25.
//
import UIKit

final class AvatarLoader {
    private(set) var avatar: UIImage?
    
    private let urlSession: URLSession = .shared
    private var task: URLSessionTask?
    
    static let shared = AvatarLoader()
    static let didChangeNotification = Notification.Name(rawValue: "AvatarLoaderDidChange")
//    private var url: URL {
//        guard let url = URL(string: "https://picsum.photos/200") else { // ресурс работет только с ВПН
//            preconditionFailure("Unable to convert string to url")
//        }
//        return url
//    }
    
    func loadAvatar(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error image download: \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
}
