//
//  FutureEstimationProviderView.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 18.12.20.
//

import SwiftUI
import SwiftUICharts

struct FutureEstimationProviderView: View {
    @ObservedObject var futureEstimationProvider: FutureEstimationProvider
    @AppStorage(UserDefaultsKeys.maximumEstimationInterval) var maximumEstimationInterval = DefaultSettings.maximumEstimationInterval
    var body: some View {
        VStack {
            BasicMeasurementMetricPickerView(activeMetric: .init(get: {
                futureEstimationProvider.metric
            }, set: { value, _ in
                futureEstimationProvider.metric = value
            }))
            Stepper("Estimation interval: \(futureEstimationProvider.estimationInterval.nDaysHumanReadable)", value: .init(get: {
                futureEstimationProvider.estimationInterval
            }, set: { new, _ in
                futureEstimationProvider.estimationInterval = new
            }), in: (1...maximumEstimationInterval))
            if let data = futureEstimationProvider.data {
                LineView(data: data)
            } else {
                VStack {
                    Spacer()
                    Text("There is no such data available for this region. Please try another metric.")
                    Spacer()
                }
                .padding(.vertical)
            }
            Text("Please note that this is of course a way over-simplified modeling, based on the numbers of just the last day, modeled by just an exponential function. This is not a realistic estimation or prediction by any means.")
        }
        .padding()
        .navigationTitle("Future estimations")
    }
}

struct FutureEstimationProviderView_Previews: PreviewProvider {
    static var previews: some View {
        FutureEstimationProviderView(futureEstimationProvider: FutureEstimationProvider(provider: MockData.countries[0], estimationInterval: 7, metric: .confirmed))
    }
}
