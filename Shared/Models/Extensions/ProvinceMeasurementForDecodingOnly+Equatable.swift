//
//  ProvinceMeasurementForDecodingOnly+Equatable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

extension ProvinceMeasurementForDecodingOnly: Equatable {
    static func == (lhs: ProvinceMeasurementForDecodingOnly, rhs: ProvinceMeasurementForDecodingOnly) -> Bool {
        let a = lhs.active == rhs.active
        let ad = lhs.activeDiff == rhs.activeDiff
        let c = lhs.confirmed == rhs.confirmed
        let cd = lhs.confirmedDiff == rhs.confirmedDiff
        let d = lhs.deaths == rhs.deaths
        let dd = lhs.deathsDiff == rhs.deathsDiff
        let cfr = round(lhs.fatalityRate) == round(rhs.fatalityRate)
        let r = lhs.recovered == rhs.recovered
        let rd = lhs.recoveredDiff == rhs.recoveredDiff
        let re = lhs.region == rhs.region
        
        return a && ad && c && cd && d && dd && cfr && r && rd && re
    }
}
