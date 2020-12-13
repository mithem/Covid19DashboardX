//
//  CustomDecodable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 06.12.20.
//

import Foundation

protocol CustomDecodable: Decodable {
    associatedtype Decoder: CustomJSONDecoderProtocol
    static func decode(from: Data?) -> Result<Self, CustomDecodableError>
}

extension CustomDecodable {
    static func decode(from: Data?) -> Result<Self, CustomDecodableError> {
        guard let data = from else { return .failure(.noData) }
        do {
            let result = try Decoder().decode(Self.self, from: data)
            return .success(result)
        } catch {
            if let error = error as? DecodingError {
                return .failure(.decodingError(error))
            } else {
                return .failure(.other(error))
            }
        }
    }
}
