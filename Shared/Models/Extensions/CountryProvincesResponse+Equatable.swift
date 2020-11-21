//
//  CountryProvincesResponse+Equatable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

extension CountryProvincesResponse: Equatable {
    static func == (lhs: CountryProvincesResponse, rhs: CountryProvincesResponse) -> Bool {lhs.data == rhs.data}
}
