//
//  ProvinceSummaryMetricPickerView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 24.10.20.
//

import SwiftUI

struct ProvinceSummaryMetricPickerView: View {
    @Binding var activeMetric: Province.SummaryMetric
    var body: some View {
        Picker("Summary metric", selection: $activeMetric) {
            ForEach(Province.SummaryMetric.allCases) { value in
                Text(value.shortDescription).tag(value)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct ProvinceSummaryMetricPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ProvinceSummaryMetricPickerView(activeMetric: .constant(.active))
    }
}
