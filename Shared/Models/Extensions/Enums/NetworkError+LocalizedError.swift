//
//  NetworkError+LocalizedError.swift
//  Covid19DashboardXTests
//
//  Created by Miguel Themann on 22.11.20.
//

import Foundation

extension NetworkError: LocalizedError {
    var localizedDescription: String {
        func s(_ key: String) -> String {
            return NSLocalizedString(key, comment: key)
        }
        switch self {
        case .serviceTemporarilyNotAvailable:
            return s("network_err_temporarily_not_available")
        case .invalidResponse(response: let response):
            return "\(s("network_err_invalid_response"))\(response)"
        case .noResponse:
            return s("network_err_no_response")
        case .urlError(let error):
            return error.localizedDescription
        case .noNetworkConnection:
            return s("network_err_no_network_connection")
        case .constrainedNetwork:
            return s("network_err_contrained_network")
        case .cachingInProgress:
            return s("network_err_caching_in_progress")
        case .otherWith(error: let error):
            return error.localizedDescription
        case .other:
            return s("unkown_error")
        }
    }
}
