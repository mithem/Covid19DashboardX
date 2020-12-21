//
//  GlobalMeasurement.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

struct GlobalMeasurement: Equatable, SummaryProvider {
    var id = "Global"
    let lastUpdate: Date
    let totalConfirmed: Int
    let newConfirmed: Int
    let totalDeaths: Int
    let newDeaths: Int
    let totalRecovered: Int
    let newRecovered: Int
    let active: Int
    let newActive: Int?
    let caseFatalityRate: Double?
    
    let description = "Global"
    
    var activeCases: Int? { active }
}
