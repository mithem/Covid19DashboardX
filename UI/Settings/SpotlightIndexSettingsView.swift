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
    @AppStorage(UserDefaultsKeys.disableSpotlightIndexing) var disableSpotlightIndexing = DefaultSettings.disableSpotlightIndexing
    var body: some View {
        Form {
            Toggle("Enable spotlight", isOn: Binding(get: {!disableSpotlightIndexing}, set: { newValue in
                disableSpotlightIndexing = !newValue
                if disableSpotlightIndexing {
                    deleteIndexForSpotlight { error in
                        presentActionSheet(error)
                    }
                }
            }))
            Button("Clear index") {
                deleteIndexForSpotlight { error in
                    presentActionSheet(error)
                }
            }
            .disabled(disableSpotlightIndexing)
            Text("Enabling spotlight indexing makes the countries and provinces you viewed searchable from Apple's Spotlight search. You can clear the index if it seems like something went wrong indexing.")
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text(error == nil ? "Cleared index" : "Error clearing index"), message: Text(error?.localizedDescription ?? "You can close this."), buttons: [.default(Text("OK"))])
        }
        .navigationTitle("Spotlight")
    }
    
    func presentActionSheet(_ error: Error?) {
        self.error = error
        if error != nil {
            showingActionSheet = true
        }
    }
}

struct SpotlightIndexSettings_Previews: PreviewProvider {
    static var previews: some View {
        SpotlightIndexSettingsView()
    }
}
