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
    let activeMetric: Province.SummaryMetric
    @ObservedObject var manager: DataManager
    var body: some View {
        NavigationLink(destination: ProvinceDetailView(province: province)) {
            Text(province.name.localizedCapitalized + ": ") + province.summaryFor(metric: activeMetric, colorNumbers: colorNumbers, colorTreshold: manager.colorTreshold, colorGrayArea: manager.colorGrayArea, reversed: false)
        }
    }
}

struct ProvinceInlineView_Previews: PreviewProvider {
    static var previews: some View {
        ProvinceInlineView(province: countriesForPreviews[0].provinces.first!, colorNumbers: true, activeMetric: .confirmed, manager: DataManager())
    }
}
