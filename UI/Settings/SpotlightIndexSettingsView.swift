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
            Toggle("enable_spotlight", isOn: Binding(get: {!disableSpotlightIndexing}, set: { newValue in
                disableSpotlightIndexing = !newValue
                if disableSpotlightIndexing {
                    deleteIndexForSpotlight { error in
                        presentActionSheet(error)
                    }
                }
            }))
            Button("clear_index") {
                deleteIndexForSpotlight { error in
                    presentActionSheet(error)
                }
            }
            .disabled(disableSpotlightIndexing)
            Text("spotlight_indexing_description")
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text(error == nil ? "cleared_index" : "error_clearing_index"), message: Text(error?.localizedDescription ?? "you_can_close_this"), buttons: [.default(Text("ok"))])
        }
        .navigationTitle("spotlight")
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
