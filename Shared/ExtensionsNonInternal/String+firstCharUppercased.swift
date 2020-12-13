//
//  String+firstCharUppercased.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 12.12.20.
//

import Foundation

extension String {
    func firstCharUppercased() -> String {
        prefix(1).uppercased() + dropFirst()
    }
}
