//
//  GradientColor+reversed.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 28.02.21.
//

import Foundation
import SwiftUICharts

extension GradientColor {
    var reversed: Self {
        .init(start: end, end: start)
    }
}
