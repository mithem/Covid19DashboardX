//
//  UserDefaultsKeys.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

struct UserDefaultsKeys {
    static let activeMetric = "activeMetric"
    static let provinceMetric = "provinceMetric"
    static let colorNumbers = "colorNumbers"
    static let dataRepresentationType = "dataRepresentationType"
    static let maximumN = "maximumMovingAverage"
    static let currentN = "currentN"
    static let colorThresholdForPercentages = "colorThresholdForPercentages"
    static let colorGrayAreaForPercentages = "colorGrayAreaForPercentages"
    static let caseFatalityRateGreenTreshold = "caseFatalityRateGreenTreshold"
    static let caseFatalityRateRedTreshold = "caseFatalityRateRedTreshold"
    static let ignoreLowDataMode = "ignoreLowDataMode"
    static let notificationsEnabled = "notificationsEnabled"
    static let notificationDate = "notificationDate"
    static let notificationIdentifiers = "notificationIdentifiers"
}
