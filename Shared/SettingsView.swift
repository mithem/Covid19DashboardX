//
//  SettingsView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 04.10.20.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(UserDefaultsKeys.colorNumbers) var colorNumbers = false
    var body: some View {
        Form {
            Toggle("Color numbers", isOn: $colorNumbers)
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
