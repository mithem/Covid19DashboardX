//
//  JSONDecoder.KeyDecodingStrategy+convertFromPascalCase.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

extension JSONDecoder.KeyDecodingStrategy {
    // https://stackoverflow.com/questions/60746366/decode-a-pascalcase-json-with-jsondecoder
    static var convertFromPascalCase: JSONDecoder.KeyDecodingStrategy {
        return .custom { keys -> CodingKey in
            // keys array is never empty
            let key = keys.last!
            // Do not change the key for an array
            guard key.intValue == nil else {
                return key
            }

            let codingKeyType = type(of: key)
            let newStringValue = key.stringValue.firstCharLowercased()

            return codingKeyType.init(stringValue: newStringValue)!
        }
    }
}
