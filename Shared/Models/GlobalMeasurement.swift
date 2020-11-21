//
//  GlobalMeasurement.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

struct GlobalMeasurement: Decodable, Equatable, SummaryProvider {
    let totalConfirmed: Int
    let newConfirmed: Int
    let totalDeaths: Int
    let newDeaths: Int
    let totalRecovered: Int
    let newRecovered: Int
    let active: Int?
    let caseFatalityRate: Double?
    
    var activeCases: Int? { active ?? totalConfirmed - totalRecovered - totalDeaths }
}
