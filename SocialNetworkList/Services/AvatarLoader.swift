//
//  AvatarLoader.swift
//  SocialNetworkList
//
//  Created by Ilya Nikitash on 3/6/25.
//
import UIKit

final class AvatarLoader {
    private let urlSession: URLSession = .shared
    static let shared = AvatarLoader()
    
    func loadAvatar(url: URL, completion: @escaping (UIImage?) -> Void) {
        urlSession.dataTask(with: url) { data, response, error in
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
