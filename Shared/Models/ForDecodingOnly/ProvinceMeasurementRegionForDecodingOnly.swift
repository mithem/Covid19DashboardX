//
//  ProvinceMeasurementRegionForDecodingOnly.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

struct ProvinceMeasurementRegionForDecodingOnly: Decodable, Equatable {
    let iso: String
    let name: String
    let province: String
    let lat: String?
    let long: String?
}
