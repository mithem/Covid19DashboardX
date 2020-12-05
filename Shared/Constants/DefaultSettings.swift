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
    static let colorTresholdForDeltas = 0.02
    static let colorGrayAreaForDeltas = 0.005
    static let colorTresholdForPercentages = 0.01
    static let colorGrayAreaForPercentages = 0.005
    static let notificationsEnabled = false
    static let notificationDate = Calendar.current.date(from: DateComponents(hour: 0, minute: 0))!
    static let widgetCountry = "USA"
    static let disableSpotlightIndexing = false
    static let dataRepresentationType = DataRepresentationType.normal
}
