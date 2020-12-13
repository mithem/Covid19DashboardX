//
//  NetworkError+LocalizedError.swift
//  Covid19DashboardXTests
//
//  Created by Miguel Themann on 22.11.20.
//

import Foundation

extension NetworkError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .invalidResponse(response: let response):
            return "Invalid response from server: \(response)"
        case .noResponse:
            return "No response from server."
        case .urlError(let error):
            return error.localizedDescription
        case .noNetworkConnection:
            return "No network connection."
        case .constrainedNetwork:
            return "Low data mode is on."
        case .cachingInProgress:
            return "Serverside caching in progress. Please try again later."
        case .otherWith(error: let error):
            return error.localizedDescription
        case .other:
            return "Unkown."
        }
    }
}
