//
//  CountryProvincesResponse.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

/// A response when requesting (current) data for all provinces of a country
struct CountryProvincesResponse: CustomDecodable {
    let data: [ProvinceMeasurementForDecodingOnly]
    typealias Decoder = CovidDashApiDotComJSONDecoder
}
