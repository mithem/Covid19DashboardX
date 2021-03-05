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
                NavigationLink("general", destination: GeneralSettingsView())
                NavigationLink("notifications", destination: NotificationSettingsView())
                NavigationLink("spotlight", destination: SpotlightIndexSettingsView())
            }
            Section {
                NavigationLink("other", destination: OtherSettingsView())
                NavigationLink("attributions", destination: AttributionsSettingsView())
            }
        }
        .navigationTitle("settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(manager: DataManager())
    }
}
