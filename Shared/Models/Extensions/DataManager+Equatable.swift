//
//  DataManager+Equatable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 22.11.20.
//

import Foundation

extension DataManager: Equatable {
    static func == (lhs: DataManager, rhs: DataManager) -> Bool {
        return lhs.countries == rhs.countries
    }
}
