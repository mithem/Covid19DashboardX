//
//  Country+Equatable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

extension Country: Equatable {
    static func == (lhs: Country, rhs: Country) -> Bool {
        let c = lhs.code == rhs.code
        let n = lhs.name == rhs.name
        let m = lhs.measurements == rhs.measurements
        
        return c && n && m
    }
}
