//
//  BasicMeasurementMetricPickerView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 07.10.20.
//

import SwiftUI

struct BasicMeasurementMetricPickerView: View {
    @Binding var activeMetric: BasicMeasurementMetric
    var body: some View {
        Picker("Measurement metric", selection: $activeMetric) {
            Text("Confirmed").tag(BasicMeasurementMetric.confirmed)
            Text("Deaths").tag(BasicMeasurementMetric.deaths)
            Text("Recovered").tag(BasicMeasurementMetric.recovered)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct BasicMeasurementMetricPickerView_Previews: PreviewProvider {
    static var previews: some View {
        BasicMeasurementMetricPickerView(activeMetric: Binding.constant(BasicMeasurementMetric.confirmed))
    }
}
