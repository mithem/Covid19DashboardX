//
//  CovidDashApiDotComJSONDecoder.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 20.11.20.
//

import Foundation

class CovidDashApiDotComJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.covidDashApiDotComDateFormat
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        keyDecodingStrategy = .convertFromSnakeCase
        dateDecodingStrategy = .formatted(formatter)
    }
}
