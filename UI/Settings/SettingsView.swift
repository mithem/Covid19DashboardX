//
//  SettingsView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 04.10.20.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var manager: DataManager
    var body: some View {
        Form {
            Section {
                NavigationLink("General", destination: GeneralSettingsView())
                NavigationLink("Notifications", destination: NotificationSettingsView())
                NavigationLink("Spotlight", destination: SpotlightIndexSettingsView())
                NavigationLink("Widget", destination: WidgetSettingsView(manager: manager))
            }
            Section {
                NavigationLink("Other", destination: OtherSettingsView())
                NavigationLink("Attributions", destination: AttributionsSettingsView())
            }
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(manager: DataManager())
    }
}
