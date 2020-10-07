//
//  shared.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import Foundation

/// Take measurements and settings and give back Doubles that SwiftUICharts can work with.
/// - Note: dataRepresentation is applied to the Y-Axis.
/// - Complexity: O(n)
/// - Parameters:
///   - measurements: CountryHistoryMeasurements to use
///   - metric: BasicMeasurementMetric to use
///   - dataRepresentation: DataRepresentationType to calculate values for
/// - Returns: double data 🚀
func getData(_ measurements: [CountryHistoryMeasurement], metric: BasicMeasurementMetric, dataRepresentation: DataRepresentationType) -> [Double] {
    func appropriateFunction(_ y: Int) -> Int {
        switch dataRepresentation {
        case .normal:
            return y
        case .quadratic:
            return _quadratic(value: y)
        case .sqRoot:
            return _sqRoot(value: y)
        case .logarithmic:
            return _logarithmic(value: y)
        }
    }
    let values = measurements.map {Double(appropriateFunction($0.metric(for: metric)))}
    return values
}

func _quadratic(value: Int) -> Int {value ^ 2}
func _sqRoot(value: Int) -> Int {Int(round(sqrt(Double(value))))}
func _logarithmic(value: Int) -> Int {
    let v2 = log(Double(value))
    if v2 == -1 * .infinity { return 0 }
    let v1 = round(v2)
    return Int(v1)
}
