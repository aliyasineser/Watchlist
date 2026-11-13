//
//  RequestManager.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

protocol RequestManager {
    var apiManager: APIManager { get }
    var parser: DataParser { get }
    func initRequest<T: Decodable>(with data: NetworkRequest) async throws -> T
}

final class DefaultRequestManager: RequestManager {
    let apiManager: APIManager
    let parser: DataParser

    init(
        apiManager: APIManager = DefaultAPIManager(),
        parser: DataParser = DefaultDataParser()
    ) {
        self.apiManager = apiManager
        self.parser = parser
    }

    func initRequest<T: Decodable>(with data: NetworkRequest) async throws -> T {
        let data = try await apiManager.initRequest(with: data)
        let decoded: T = try parser.parse(data: data)
        return decoded
    }
}

// MARK: - Returns Data Parser
extension RequestManager {
    var parser: DataParser {
        return DefaultDataParser()
    }
}
