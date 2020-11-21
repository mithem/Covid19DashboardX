//
//  SummaryResponse.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

struct SummaryResponse: Decodable, Equatable {
    let global: GlobalMeasurement
    let countries: [CountrySummaryMeasurementForDecodingOnly]
    let date: Date
}
