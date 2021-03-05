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
            Text("data_from_colon")
                .bold()
            VStack {
                Link(UsefulURLs.covid19apiDotCom.host!, destination: UsefulURLs.covid19apiDotCom)
                    .buttonStyle(CustomButtonStyle())
                Link(UsefulURLs.covidDashApiDotCom.host!, destination: UsefulURLs.covidDashApiDotCom)
                    .buttonStyle(CustomButtonStyle())
            }
        }
        .navigationTitle("attributions")
    }
}

struct AttributionsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AttributionsSettingsView()
    }
}
