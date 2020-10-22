//
//  CountryInlineView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 10.10.20.
//

import SwiftUI

struct CountryInlineView: View {
    let country: Country
    let colorNumbers: Bool
    @Binding var activeMetric: BasicMeasurementMetric
    @ObservedObject var manager: DataManager // to pass along to CountryView
    var body: some View {
        HStack {
            NavigationLink(destination: CountryView(manager: manager, country: country)) {
                Text(country.name.localizedCapitalized + " ") + country.summaryFor(metric: activeMetric, colorNumbers: colorNumbers, colorTreshold: manager.colorThreshold, colorGrayArea: manager.colorGrayArea, reversed: false)
            }
        }
    }
}

struct CountryInlineView_Previews: PreviewProvider {
    static var previews: some View {
        CountryInlineView(country: countriesForPreviews[0], colorNumbers: true, activeMetric: .constant(.confirmed), manager: DataManager())
    }
}
