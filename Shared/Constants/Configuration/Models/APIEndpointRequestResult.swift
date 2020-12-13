//
//  APIEndpointRequestResult.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 13.12.20.
//

import Foundation

enum APIEndpointRequestResult<Success: CustomDecodable, Fallback: CustomDecodable> {
    case success(_ data: Success)
    case fallbackSuccessful(_ data: Fallback)
    case failure(_ error: NetworkError)
    
    func toStandardResult() -> Result<Success, NetworkError> where Success == Fallback {
        switch self {
        case .success(let data):
            return .success(data)
        case .fallbackSuccessful(let data):
            return .success(data)
        case .failure(let error):
            return .failure(error)
        }
    }
}
