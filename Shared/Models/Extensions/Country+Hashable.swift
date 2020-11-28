//
//  Country+Hashable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 28.11.20.
//

import Foundation

extension Country: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(code)
        hasher.combine(latest)
        hasher.combine(measurements)
        hasher.combine(provinces)
    }
}
