//
//  CustomJSONDecoder.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 06.12.20.
//

import Foundation

protocol CustomJSONDecoder: JSONDecoder {
    associatedtype T: CustomDecodable
    func decode(from data: Data?) -> Result<T, CustomDecodableError>
}

extension CustomJSONDecoder {
    func decode(from data: Data?) -> Result<T, CustomDecodableError> {
        guard let data = data else { return .failure(.noData) }
        do {
            let result = try decode(T.self, from: data)
            return .success(result)
        } catch {
            return .failure(.other(error))
        }
    }
}
