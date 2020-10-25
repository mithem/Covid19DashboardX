//
//  OtherSettingsView.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 24.10.20.
//

import SwiftUI

struct OtherSettingsView: View {
    @State private var showingResetToDefaultsActionSheet = false
    var body: some View {
        Form {
            Section {
            Link(destination: UsefulURLs.newFeatureSuggestion) {
                Item(image: "star.circle", title: "Suggest a feature")
            }
            Link(destination: UsefulURLs.newBugReport) {
                Item(image: "exclamationmark.triangle", title: "File a bug report")
            }
            Link(destination: UsefulURLs.mailToMe) {
                Item(image: "envelope", title: "Get support")
            }
            }
            Section {
                Button("Reset to defaults") {
                    showingResetToDefaultsActionSheet = true
                }
                .actionSheet(isPresented: $showingResetToDefaultsActionSheet) {
                    ActionSheet(title: Text("Reset to defaults?"), message: Text("Are you sure you want to reset to defaults? This cannot be undone."), buttons: [.destructive(Text("Reset")) {resetSettingsToDefaults()}, .cancel()])
                }
            }
        }
        .navigationTitle("Other")
    }
}

fileprivate struct Item: View {
    let image: String
    let title: String
    var body: some View {
        HStack {
            Image(systemName: image)
                .foregroundColor(.accentColor)
            Text(title)
                .foregroundColor(.primary)
        }
    }
}

struct OtherSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        OtherSettingsView()
    }
}
