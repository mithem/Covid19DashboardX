//
//  CountryViewSettingsView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 07.10.20.
//

import SwiftUI

struct CountryViewSettingsView: View {
    let country: Country
    @AppStorage(UserDefaultsKeys.dataRepresentationType) var dataRepresentationType = DataRepresentationType.normal
    @State private var showingMovingAveragesConfigurationScreen = false
    var body: some View {
        Form {
            Picker("data_representation", selection: $dataRepresentationType) {
                ForEach(DataRepresentationType.allCases) { reprType in
                    Text(reprType.rawValue).tag(reprType)
                }
            }
        }
        .navigationTitle("visualization_settings")
    }
}

