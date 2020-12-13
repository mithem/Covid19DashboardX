//
//  JSONEncoder.KeyEncodingStrategy.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 12.12.20.
//

import Foundation

extension JSONEncoder.KeyEncodingStrategy {
    static var convertToPascalCase: JSONEncoder.KeyEncodingStrategy {
        return .custom { keys -> CodingKey in
            let last = keys.last!
            
            let keyType = type(of: last)
            let newStringValue = last.stringValue.firstCharUppercased()
            
            return keyType.init(stringValue: newStringValue) ?? last
        }
    }
}
