//
//  String+firstCharLowercased.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

extension String {
    // https://stackoverflow.com/questions/60746366/decode-a-pascalcase-json-with-jsondecoder
    func firstCharLowercased() -> String {
        prefix(1).lowercased() + dropFirst()
    }
}
