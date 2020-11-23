//
//  SpotlightIndexSettingsView.swift
//  Covid19DashboardXTests
//
//  Created by Miguel Themann on 22.11.20.
//

import SwiftUI

struct SpotlightIndexSettingsView: View {
    @State private var showingActionSheet = false
    @State private var error: Error? = nil
    var body: some View {
        Form {
            Button("Clear index") {
                deleteIndexForSpotlight { error in
                    self.error = error
                    showingActionSheet = true
                }
            }
            Text("You can clear the index if something is sub-optimal.")
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text(error == nil ? "Cleared index" : "Error clearing index"), message: Text(error?.localizedDescription ?? "You can close this."), buttons: [.default(Text("OK"))])
        }
        .navigationTitle("Spotlight")
    }
}

struct SpotlightIndexSettings_Previews: PreviewProvider {
    static var previews: some View {
        SpotlightIndexSettingsView()
    }
}
