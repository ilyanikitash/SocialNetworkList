//
//  PostLoader.swift
//  SocialNetworkList
//
//  Created by Ilya Nikitash on 3/5/25.
//
import Foundation

final class PostLoader {
    private(set) var posts: [PostModel] = []
    static let shared = PostLoader()
    static let didChangeNotification = Notification.Name(rawValue: "PostLoaderDidChange")
    private let urlSession: URLSession = .shared
    private var task: URLSessionTask?
    private var url: URL {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            preconditionFailure("Unable to convert string to url")
        }
        return url
    }
    
    func fetchPosts() {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        
        let request = URLRequest(url: url)
        task?.cancel()
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PostResult], Error>) in
            guard let self else { return }
            switch result {
            case .success(let response):
                let newPosts = response.map {PostModel(result: $0)}
                DispatchQueue.main.async {
                    self.posts.append(contentsOf: newPosts)
                    NotificationCenter.default.post(name: PostLoader.didChangeNotification, object: nil)
                }
                
            case .failure(_):
                print("error")
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    print("[\(String(describing: self)).\(#function)]: \(NetworkError.httpStatusCode(statusCode)) - Network error with status code \(statusCode)")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("[\(String(describing: self)).\(#function)]: \(NetworkError.urlRequestError(error)) -  URL request error, \(error.localizedDescription)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("[\(String(describing: self)).\(#function)]: \(NetworkError.urlSessionError) -  URL session error")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = SnakeCaseJSONDecoder()
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let object = try decoder.decode(T.self, from: data)
                    completion(.success(object))
                } catch {
                    print("Error decoding: \(error.localizedDescription), Data: \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("[\(String(describing: self)).\(#function)]: - Error getting data: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        return task
    }
}
