//
//  Untitled.swift
//  SocialNetworkList
//
//  Created by Ilya Nikitash on 3/6/25.
//
import Foundation

final class SnakeCaseJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
