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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
