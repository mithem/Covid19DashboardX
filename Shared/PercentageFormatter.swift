//
//  PercentageFormatter.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 22.10.20.
//

import Foundation

class PercentageFormatter: NumberFormatter {
    override init() {
        super.init()
        numberStyle = .percent
        minimumFractionDigits = 1
        maximumFractionDigits = 5
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
