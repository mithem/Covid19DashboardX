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
    let colorDeltaTreshold: Double
    let colorDeltaGrayArea: Double
    @Binding var activeMetric: BasicMeasurementMetric
    @ObservedObject var manager: DataManager // to pass along to CountryView
    var body: some View {
        HStack {
            NavigationLink(destination: CountryView(manager: manager, country: country)) {
                Text(country.name.localizedCapitalized + ": ") + country.summaryFor(metric: activeMetric, colorNumbers: colorNumbers, colorDeltaTreshold: colorDeltaTreshold, colorDeltaGrayArea: colorDeltaGrayArea, reversed: false)
            }
        }
    }
}

struct CountryInlineView_Previews: PreviewProvider {
    static var previews: some View {
        CountryInlineView(country: MockData.countries[0], colorNumbers: true, colorDeltaTreshold: DefaultSettings.colorTresholdForPercentages, colorDeltaGrayArea: DefaultSettings.colorGrayAreaForPercentages, activeMetric: .constant(.confirmed), manager: DataManager())
    }
}
