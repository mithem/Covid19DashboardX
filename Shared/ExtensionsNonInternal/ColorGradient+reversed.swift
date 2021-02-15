//
//  ColorGradient+reversed.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 15.02.21.
//

import SwiftUICharts

extension ColorGradient {
    var reversed: Self {
        .init(endColor, startColor)
    }
}
