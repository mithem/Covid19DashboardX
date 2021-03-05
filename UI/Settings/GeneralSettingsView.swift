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
    @AppStorage(UserDefaultsKeys.maximumEstimationInterval) var maximumEstimationInterval = DefaultSettings.maximumEstimationInterval
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
                Toggle("color_numbers", isOn: $colorNumbers)
                Stepper("\(NSLocalizedString("max_moving_avg_interval_colon", comment: "max_moving_avg_interval_colon")) \(maximumN.nDaysHumanReadable)", value: $maximumN, in: 1...1_000_000) // should be sufficient for now
                Stepper("\(NSLocalizedString("max_future_estimation_interval_colon", comment: "max_future_estimation_interval_colon")) \(maximumEstimationInterval.nDaysHumanReadable)", value: $maximumEstimationInterval, in: 1...3652) // 10 years
                Toggle("ignore_low_data_mode", isOn: $ignoreLowDataMode)
            }
            Section {
                Stepper("\(NSLocalizedString("cfr_color_treshold_colon", comment: "cfr_color_treshold_colon")) \(percent(colorPercentagesTreshold))", value: $colorPercentagesTreshold, in: 0...0.5, step: 0.001)
                Stepper("\(NSLocalizedString("cfr_color_gray_area_colon", comment: "cfr_color_gray_area_colon")) \(percent(colorPercentagesGrayArea))", value: $colorPercentagesGrayArea, in: 0...0.25, step: 0.0005)
                Text("\(NSLocalizedString("cfrs_of", comment: "cfrs_of")) \(percent(colorPercentagesTreshold)) \(NSLocalizedString("with_a_derivation_of_plusminus", comment: "with_a_derivation_of_plusminus")) \(percent(colorPercentagesGrayArea)) \(NSLocalizedString("will_be_displayed_etc", comment: "will_be_displayed_etc"))")
                    .foregroundColor(.secondary)
            }
            Section {
                Stepper("\(NSLocalizedString("new_cases_proportion_color_treshold_colon", comment: "new_cases_proportion_color_treshold_colon"))\(percent(colorDeltaTreshold))", value: $colorDeltaTreshold, in: 0...0.75, step: 0.001)
                Stepper("\(NSLocalizedString("new_cases_proportion_gray_area_colon", comment: "new_cases_proportion_gray_area_colon"))\(percent(colorDeltaGrayArea))", value: $colorDeltaGrayArea, in: 0...0.375, step: 0.0005)
                Text("\(NSLocalizedString("when_the_ratio_of_new_cases_to_total_ones", comment: "when_the_ratio_of_new_cases_to_total_ones")) \(percent(colorDeltaTreshold)), ±\(percent(colorDeltaGrayArea))\(NSLocalizedString("comma_it_will_be_displayed_etc", comment: "comma_it_will_be_displayed_etc"))")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("general")
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}
