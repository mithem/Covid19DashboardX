//
//  DefaultSettings.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

struct DefaultSettings {
    static let colorNumbers = false
    static let measurementMetric = BasicMeasurementMetric.confirmed
    static let provinceMetric = Province.SummaryMetric.confirmed
    static let maximumN = 90
    static let ignoreLowDataMode = false
    static let colorTresholdForPercentages = 0.0125
    static let colorGrayAreaForPercentages = 0.0025
    static let notificationsEnabled = false
    static let notificationDate = Calendar.current.date(from: DateComponents(hour: 0, minute: 0))!
}
