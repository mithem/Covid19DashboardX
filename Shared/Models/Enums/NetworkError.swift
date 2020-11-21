//
//  NetworkError.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

enum NetworkError: Error, Equatable, LocalizedError {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {lhs.localizedDescription == rhs.localizedDescription} // no better way?
    
    case invalidResponse(response: String)
    case noResponse // don't actually know whether that can happen without a timeout error 🤔
    case urlError(_ error: URLError)
    case noNetworkConnection
    case constrainedNetwork
    case otherWith(error: Error)
    case other
    
    var localizedDescription: String {
        switch self {
        case .invalidResponse:
            return "Invalid response from server."
        case .noResponse:
            return "No response from server."
        case .urlError(let error):
            return error.localizedDescription
        case .noNetworkConnection:
            return "No network connection."
        case .constrainedNetwork:
            return "Low data mode is on."
        case .otherWith(error: let error):
            return error.localizedDescription
        case .other:
            return "Unkown."
        }
    }
}
