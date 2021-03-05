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
                Item(image: "star.circle", title: NSLocalizedString("suggest_a_feature", comment: "suggest_a_feature"))
            }
            Link(destination: UsefulURLs.newBugReport) {
                Item(image: "exclamationmark.triangle", title: NSLocalizedString("file_a_bug_report", comment: "file_a_bug_report"))
            }
            Link(destination: UsefulURLs.mailToMe) {
                Item(image: "envelope", title: NSLocalizedString("get_support", comment: "get_support"))
            }
            }
            Section {
                Button("reset_to_defaults") {
                    showingResetToDefaultsActionSheet = true
                }
                .actionSheet(isPresented: $showingResetToDefaultsActionSheet) {
                    ActionSheet(title: Text("reset_to_defaults_question"), message: Text("reset_to_defaults_question_confirmation"), buttons: [.destructive(Text("reset")) {resetSettingsToDefaults()}, .cancel()])
                }
            }
        }
        .navigationTitle("other")
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
