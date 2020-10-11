//
//  SettingsView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 04.10.20.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(UserDefaultsKeys.colorNumbers) var colorNumbers = DefaultSettings.colorNumbers
    @AppStorage(UserDefaultsKeys.maximumN) var maximumN = 90
    var body: some View {
        Form {
            Toggle("Color numbers", isOn: $colorNumbers)
            Stepper("Maximum moving average interval: \(maximumN.nDaysHumanReadable)", value: $maximumN, in: 1...1_000_000) // should be sufficient for now
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
