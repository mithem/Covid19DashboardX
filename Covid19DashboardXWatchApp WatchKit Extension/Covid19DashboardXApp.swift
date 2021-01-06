//
//  Covid19DashboardXApp.swift
//  Covid19DashboardXWatchApp WatchKit Extension
//
//  Created by Miguel Themann on 01.01.21.
//

import SwiftUI

@main
struct Covid19DashboardXApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(manager: DataManager())
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
