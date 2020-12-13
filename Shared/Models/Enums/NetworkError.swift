//
//  NetworkError.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse(response: String)
    case noResponse // don't actually know whether that can happen without a timeout error 🤔
    case urlError(_ error: URLError)
    case noNetworkConnection
    case constrainedNetwork
    case cachingInProgress
    case otherWith(error: Error)
    case other
    
    init(error: Error) {
        if let urlError = error as? URLError {
            self = .urlError(urlError)
        } else if let decodable = error as? CustomDecodableError {
            switch decodable {
            case .noData:
                self = .noResponse
            case .decodingError(let error):
                self = .invalidResponse(response: error.localizedDescription)
            case .other(let error):
                self = .init(error: error)
            }
        } else if let networkError = error as? NetworkError {
            self = networkError
        } else {
            self = .otherWith(error: error)
        }
    }
    
    init?(error: Error?) {
        guard let e = error else { return nil }
        self.init(error: e)
    }
}
