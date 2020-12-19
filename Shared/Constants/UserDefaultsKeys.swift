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
    
    /// Proportion of new cases/deaths/recovered/etc. to total cases/... which sets the middle value.
    /// Everything under this is considered rather green than red.
    /// `absoluteNumbersDeltaGrayAreaProportion` is used to configure how broad the gray band/area shall be
    static let colorTresholdForDeltas = "absoluteRedProportion"
    /// Range of proportions of new cases/... to total cases/... to configure gray instead of green (below) or red (above)
    static let colorGrayAreaForDeltas = "absoulteGreenProportion"
    
    static let ignoreLowDataMode = "ignoreLowDataMode"
    
    static let notificationsEnabled = "notificationsEnabled"
    static let notificationDate = "notificationDate"
    static let notificationIdentifiers = "notificationIdentifiers"
    
    static let widgetCountry = "widgetCountry"
    
    static let disableSpotlightIndexing = "disableSpotlightIndexing"
    
    static let estimationInterval = "estimationInterval"
    static let maximumEstimationInterval = "maximumEstimationInterval"
}
