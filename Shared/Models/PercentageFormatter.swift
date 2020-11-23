//
//  PercentageFormatter.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 22.10.20.
//

import Foundation

class PercentageFormatter: NumberFormatter {
    private static let defaultPrecision = 5
    private var _precision: Int
    var precision: Int {
        get {
            _precision
        }
        set {
            guard newValue >= 1 else { _precision = 1; return }
            maximumFractionDigits = newValue
        }
    }
    
    init(precision: Int = defaultPrecision) {
        _precision = precision
        super.init()
        numberStyle = .percent
        minimumFractionDigits = 1
        maximumFractionDigits = precision
    }
    
    required init?(coder: NSCoder) {
        _precision = Self.defaultPrecision
        super.init(coder: coder)
    }
}
