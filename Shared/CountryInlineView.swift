//
//  CountryInlineView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 10.10.20.
//

import SwiftUI

struct CountryInlineView: View {
    let country: Country
    @EnvironmentObject var manager: DataManager // to pass along to CountryView
    @Binding var activeMetric: BasicMeasurementMetric
    var body: some View {
        HStack {
            NavigationLink(destination: CountryView(country: country).environmentObject(manager)) {
                Text(country.name.localizedCapitalized + " ") + country.summaryFor(metric: activeMetric)
            }
        }
    }
}

struct CountryInlineView_Previews: PreviewProvider {
    static var previews: some View {
        CountryInlineView(country: countriesForPreviews[0], activeMetric: .constant(.confirmed))
    }
}
