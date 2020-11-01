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
    let colorTreshold: Double
    let colorGrayArea: Double
    @Binding var activeMetric: BasicMeasurementMetric
    @ObservedObject var manager: DataManager // to pass along to CountryView
    var body: some View {
        HStack {
            NavigationLink(destination: CountryView(manager: manager, country: country)) {
                Text(country.name.localizedCapitalized + ": ") + country.summaryFor(metric: activeMetric, colorNumbers: colorNumbers, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, reversed: false)
            }
        }
    }
}

struct CountryInlineView_Previews: PreviewProvider {
    static var previews: some View {
        CountryInlineView(country: Constants.countriesForPreviews[0], colorNumbers: true, colorTreshold: 0.01, colorGrayArea: 0.005, activeMetric: .constant(.confirmed), manager: DataManager())
    }
}
