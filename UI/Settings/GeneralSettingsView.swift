//
//  GeneralSettingsView.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 24.10.20.
//

import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage(UserDefaultsKeys.colorNumbers) var colorNumbers = DefaultSettings.colorNumbers
    @AppStorage(UserDefaultsKeys.maximumN) var maximumN = DefaultSettings.maximumN
    @AppStorage(UserDefaultsKeys.ignoreLowDataMode) var ignoreLowDataMode = DefaultSettings.ignoreLowDataMode
    @AppStorage(UserDefaultsKeys.colorThresholdForPercentages) var colorTreshold = DefaultSettings.colorTresholdForPercentages
    @AppStorage(UserDefaultsKeys.colorGrayAreaForPercentages) var colorGrayArea = DefaultSettings.colorGrayAreaForPercentages
    
    let percentageFormatter: NumberFormatter
    
    var body: some View {
        Form {
            Section {
                Toggle("Color numbers", isOn: $colorNumbers)
                Stepper("Maximum moving average interval: \(maximumN.nDaysHumanReadable)", value: $maximumN, in: 1...1_000_000) // should be sufficient for now
                Toggle("Ignore low data mode", isOn: $ignoreLowDataMode)
            }
            Section {
                Stepper("Percentages color treshold: \(percentageFormatter.string(from: NSNumber(value: colorTreshold)) ?? Constants.notAvailableString)", value: $colorTreshold, in: 0...0.5, step: 0.0025)
                Stepper("Percentages color gray area: \(percentageFormatter.string(from: NSNumber(value: colorGrayArea)) ?? Constants.notAvailableString)", value: $colorGrayArea, in: 0...0.25, step: 0.00125)
                Text("CFRs of \(percentageFormatter.string(from: NSNumber(value: colorTreshold)) ?? Constants.notAvailableString) with an deviation of ±\(percentageFormatter.string(from: NSNumber(value: colorGrayArea)) ?? Constants.notAvailableString) will be displayed gray, above red, below green.")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("General")
    }
    
    init() {
        percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        percentageFormatter.minimumFractionDigits = 3
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}
