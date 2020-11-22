//
//  SettingsView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 04.10.20.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section {
                NavigationLink("General", destination: GeneralSettingsView())
                NavigationLink("Notifications", destination: NotificationSettingsView())
                NavigationLink("Spotlight", destination: SpotlightIndexSettingsView())
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
        SettingsView()
    }
}
