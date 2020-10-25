//
//  AttributionsSettingsView.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 24.10.20.
//

import SwiftUI

struct AttributionsSettingsView: View {
    var body: some View {
        VStack(spacing: 25) {
            Text("Data from:")
                .bold()
            VStack {
                Link(UsefulURLs.covid19apiDotCom.host!, destination: UsefulURLs.covid19apiDotCom)
                    .buttonStyle(CustomButtonStyle())
                Link(UsefulURLs.covidDashApiDotCom.host!, destination: UsefulURLs.covidDashApiDotCom)
                    .buttonStyle(CustomButtonStyle())
            }
        }
        .navigationTitle("Attributions")
    }
}

struct AttributionsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AttributionsSettingsView()
    }
}
