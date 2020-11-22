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
    case otherWith(error: Error)
    case other
    
    init(error: Error?) {
        if let urlError = error as? URLError {
            self = .urlError(urlError)
        } else if let networkError = error as? NetworkError {
            self = networkError
        } else if let error = error {
            self = .otherWith(error: error)
        } else {
            self = .other
        }
    }
}
