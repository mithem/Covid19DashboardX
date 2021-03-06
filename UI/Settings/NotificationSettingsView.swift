//
//  NotificationSettingsView.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 01.11.20.
//

import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {
    @AppStorage(UserDefaultsKeys.notificationsEnabled) var notificationsEnabled = DefaultSettings.notificationsEnabled
    @State private var prevDate = DefaultSettings.notificationDate
    @State private var prevToggle = UserDefaults().bool(forKey: UserDefaultsKeys.notificationsEnabled)
    @State private var notificationDate = DefaultSettings.notificationDate
    @State private var notificationAuthorizationDenied = false
    var body: some View {
        Form {
            Section {
                Toggle("enable_notifications", isOn: $notificationsEnabled)
                HStack {
                    Text("remind_me_at")
                    DatePicker("remind_me_at", selection: $notificationDate, displayedComponents: [.hourAndMinute])
                        .onAppear {
                            prevDate = notificationDate
                            prevToggle = notificationsEnabled
                            loadNotificationSettings()
                        }
                        .datePickerStyle(GraphicalDatePickerStyle())
                }
            }
            .onDisappear {
                if notificationDate != prevDate || notificationsEnabled != prevToggle { // no idea why this executes on load; removing half the notifications still is better than none; wanna use identifiers
                    let string = ISO8601DateFormatter().string(from: notificationDate)
                    UserDefaults().set(string, forKey: UserDefaultsKeys.notificationDate)
                    applyNotificationSettings()
                }
            }
            .disabled(notificationAuthorizationDenied)
            if notificationAuthorizationDenied {
                VStack {
                    Text("notifications_disabled_info")
                        .foregroundColor(.secondary)
                    Button("settings") {
                        UIApplication.shared.open(UsefulURLs.notificationSettings)
                    }
                    .buttonStyle(CustomButtonStyle())
                }
            }
        }
        .navigationTitle("notifications")
    }
    
    func loadNotificationSettings() {
        let formatter = ISO8601DateFormatter()
        var string = UserDefaults().string(forKey: UserDefaultsKeys.notificationDate)
        if string == nil {
            string = formatter.string(from: DefaultSettings.notificationDate)
        }
        guard let date =  formatter.date(from: string!) else { return }
        notificationDate = date
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print(error)
            }
            if granted {
                notificationAuthorizationDenied = false
            } else {
                notificationAuthorizationDenied = true
            }
        }
    }
    
    func applyNotificationSettings() {
        guard notificationsEnabled  else { return }
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("reminder.title", comment: "reminder.title")
        content.body = NSLocalizedString("reminder.body", comment: "reminder.body")
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: notificationDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print(error)
            } else {
                let ud = UserDefaults()
                var identifiers = ud.stringArray(forKey: UserDefaultsKeys.notificationIdentifiers) ?? []
                identifiers.append(uuidString)
                ud.set(identifiers, forKey: UserDefaultsKeys.notificationIdentifiers)
            }
        }
    }
}

struct NotificationSettings_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView()
    }
}
