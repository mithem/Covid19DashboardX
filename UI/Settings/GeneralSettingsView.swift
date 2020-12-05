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
    @AppStorage(UserDefaultsKeys.colorThresholdForPercentages) var colorPercentagesTreshold = DefaultSettings.colorTresholdForPercentages
    @AppStorage(UserDefaultsKeys.colorGrayAreaForPercentages) var colorPercentagesGrayArea = DefaultSettings.colorGrayAreaForPercentages
    @AppStorage(UserDefaultsKeys.colorTresholdForDeltas) var colorDeltaTreshold = DefaultSettings.colorTresholdForDeltas
    @AppStorage(UserDefaultsKeys.colorGrayAreaForDeltas) var colorDeltaGrayArea = DefaultSettings.colorGrayAreaForDeltas
    
    let percentageFormatter = PercentageFormatter()
    
    private func percent(_ percent: Double) -> String {
        return percentageFormatter.string(from: NSNumber(value: percent)) ?? Constants.notAvailableString
    }
    
    var body: some View {
        Form {
            Section {
                Toggle("Color numbers", isOn: $colorNumbers)
                Stepper("Maximum moving average interval: \(maximumN.nDaysHumanReadable)", value: $maximumN, in: 1...1_000_000) // should be sufficient for now
                Toggle("Ignore low data mode", isOn: $ignoreLowDataMode)
            }
            Section {
                Stepper("CFR color treshold: \(percent(colorPercentagesTreshold))", value: $colorPercentagesTreshold, in: 0...0.5, step: 0.001)
                Stepper("CFR color gray area: \(percent(colorPercentagesGrayArea))", value: $colorPercentagesGrayArea, in: 0...0.25, step: 0.0005)
                Text("CFRs of \(percent(colorPercentagesTreshold)) with an deviation of ±\(percent(colorPercentagesGrayArea)) will be displayed gray, above red, below green.")
                    .foregroundColor(.secondary)
            }
            Section {
                Stepper("New cases proportion color treshold: \(percent(colorDeltaTreshold))", value: $colorDeltaTreshold, in: 0...0.75, step: 0.001)
                Stepper("New cases proportion gray area: \(percent(colorDeltaGrayArea))", value: $colorDeltaGrayArea, in: 0...0.375, step: 0.0005)
                Text("When the ratio of new cases to total ones (confirmed, recovered, etc.) exceeds \(percent(colorDeltaTreshold)), ±\(percent(colorDeltaGrayArea)), it will be displayed green or red, respectively.")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("General")
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}
