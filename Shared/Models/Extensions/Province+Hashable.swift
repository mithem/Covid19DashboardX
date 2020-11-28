//
//  Province+Hashable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 28.11.20.
//

import Foundation

extension Province: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(active)
        hasher.combine(newActive)
        hasher.combine(totalConfirmed)
        hasher.combine(newConfirmed)
        hasher.combine(totalRecovered)
        hasher.combine(newRecovered)
        hasher.combine(totalDeaths)
        hasher.combine(newDeaths)
        hasher.combine(measurements)
    }
}
