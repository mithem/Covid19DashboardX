//
//  APIEndpoint.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 13.12.20.
//

import Foundation

protocol APIEndpoint {
    associatedtype DataType: CustomDecodable
    associatedtype FallbackDataType: CustomDecodable
    static var url: String { get }
    static var ignoreLowDataMode: Bool { get }
}

extension APIEndpoint {
    static func request(pathAppendix: String = "", queryItems: [URLQueryItem] = [], completion: @escaping (APIEndpointRequestResult<DataType, FallbackDataType>) -> Void) {
        guard let url = URL(string: url + pathAppendix) else { preconditionFailure("Invalid URL") }
        guard var components = URLComponents(string: url.absoluteString) else { preconditionFailure("Invalid URLComponents" )}
        components.queryItems = queryItems
        var request = URLRequest(url: components.url ?? url)
        request.allowsConstrainedNetworkAccess = ignoreLowDataMode || UserDefaults().bool(forKey: UserDefaultsKeys.ignoreLowDataMode)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.init(error: error)))
            } else if let data = data {
                let result = DataType.decode(from: data)
                switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    if DataType.self == FallbackDataType.self {
                        completion(.failure(NetworkError(error: error)))
                    } else {
                        switch error {
                        case .decodingError(let error):
                            let result2 = FallbackDataType.decode(from: data)
                            switch result2 {
                            case .success(let data):
                                completion(.fallbackSuccessful(data))
                            case .failure(_):
                                completion(.failure(NetworkError(error: error)))
                            }
                        case .noData:
                            completion(.failure(.noResponse))
                        case .other(let error):
                            completion(.failure(NetworkError(error: error)))
                        }
                    }
                }
            }
        }.resume()
    }
}
