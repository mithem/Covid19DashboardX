//
//  DataRepresentationType.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

enum DataRepresentationType: String, CaseIterable, Identifiable {
    var id: DataRepresentationType { self }
    
    case normal = "normal"
    case quadratic = "quadratic"
    case sqRoot = "square root"
    case logarithmic = "logarithmic"
}
