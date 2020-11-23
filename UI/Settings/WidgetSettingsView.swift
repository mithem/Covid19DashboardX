//
//  WidgetSettingsView.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 22.11.20.
//

import SwiftUI

struct WidgetSettingsView: View {
    @AppStorage(UserDefaultsKeys.widgetCountry) var code = DefaultSettings.widgetCountry
    @ObservedObject var manager: DataManager
    var body: some View {
        Form {
            Picker("Country", selection: $code) {
                ForEach(manager.countries) { country in
                    Text(country.name.localizedCapitalized).tag(country.id)
                }
            }
            Text("Pick a country for all your widgets to try to get data for.")
        }
        .navigationTitle("Widget")
    }
}

struct WidgetSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetSettingsView(manager: DataManager())
    }
}
