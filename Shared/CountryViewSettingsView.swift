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
    var body: some View {
        Form {
            Picker("Data representation", selection: $dataRepresentationType) {
                ForEach(DataRepresentationType.allCases) { reprType in
                    Text(reprType.rawValue).tag(reprType)
                }
            }
        }
        .navigationTitle("Visualization settings")
    }
}

struct CountryViewSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CountryViewSettingsView(country: countriesForPreviews[0])
    }
}
