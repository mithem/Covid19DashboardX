//
//  ProvinceInlineView.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 23.10.20.
//

import SwiftUI

struct ProvinceInlineView: View {
    let province: Province
    let colorNumbers: Bool
    let colorDeltaTreshold: Double
    let colorDeltaGrayArea: Double
    let colorPercentagesTreshold: Double
    let colorPercentagesGrayArea: Double
    let activeMetric: Province.SummaryMetric
    @ObservedObject var manager: DataManager
    var body: some View {
        NavigationLink(destination: SummaryProviderDetailView(provider: province)) {
            Text(province.name.localizedCapitalized + ": ") + province.summaryFor(metric: activeMetric, colorNumbers: colorNumbers, colorDeltaTreshold: colorPercentagesTreshold, colorDeltaGrayArea: colorPercentagesGrayArea, colorPercentagesTreshold: colorDeltaTreshold, colorPercentagesGrayArea: colorDeltaGrayArea, reversed: false)
        }
    }
}

struct ProvinceInlineView_Previews: PreviewProvider {
    static var previews: some View {
        ProvinceInlineView(province: MockData.countries[0].provinces.first!, colorNumbers: true, colorDeltaTreshold: DefaultSettings.colorTresholdForDeltas, colorDeltaGrayArea: DefaultSettings.colorGrayAreaForDeltas, colorPercentagesTreshold: DefaultSettings.colorTresholdForPercentages, colorPercentagesGrayArea: DefaultSettings.colorGrayAreaForPercentages, activeMetric: .confirmed, manager: DataManager())
    }
}
