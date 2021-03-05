//
//  FutureEstimationProviderView.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 18.12.20.
//

import SwiftUI
import SwiftUICharts

struct FutureEstimationProviderView<Provider: SummaryProvider>: View {
    @ObservedObject var futureEstimationProvider: FutureEstimationProvider<Provider>
    @AppStorage(UserDefaultsKeys.maximumEstimationInterval) var maximumEstimationInterval = DefaultSettings.maximumEstimationInterval
    @ObservedObject var manager: DataManager
    @State private var showingProviderSelectionSheet = false
    var body: some View {
        VStack {
            BasicMeasurementMetricPickerView(activeMetric: .init(get: {
                futureEstimationProvider.metric
            }, set: { value, _ in
                futureEstimationProvider.metric = value
            }))
            Stepper("\(NSLocalizedString("estimation_interval_colon", comment: "estimation_interval_colon"))\(futureEstimationProvider.estimationInterval.nDaysHumanReadable)", value: .init(get: {
                futureEstimationProvider.estimationInterval
            }, set: { new, _ in
                futureEstimationProvider.estimationInterval = new
            }), in: (1...maximumEstimationInterval))
            if let data = futureEstimationProvider.data {
                LineView(data: data)
            } else {
                VStack {
                    Spacer()
                    Text("no_data_available_for_region")
                    Spacer()
                }
                .padding(.vertical)
            }
            Text("future_estimation_disclaimer")
            if futureEstimationProvider.provider is Country {
                Button("calculate_intersect") {
                    showingProviderSelectionSheet = true
                }
                .buttonStyle(CustomButtonStyle())
            }
        }
        .sheet(isPresented: $showingProviderSelectionSheet) {
            if let summaryProvider = futureEstimationProvider.provider as? Country { // just wanna be safe (saw what happens)
                SummaryProviderSelectionView(isPresented: $showingProviderSelectionSheet, providers: manager.countries, provider: summaryProvider) { isPresented, provider -> FutureEstimationProviderCaseNumbersIntersectionView<Provider> in
                    showingProviderSelectionSheet = isPresented.wrappedValue
                    return FutureEstimationProviderCaseNumbersIntersectionView(provider1: futureEstimationProvider, provider2: FutureEstimationProvider(provider: provider as! Provider ), isPresented: $showingProviderSelectionSheet)
                }
            } else {
                Text("future_estimation_interval_error_that_shouldnt_happen")
                    .padding()
            }
        }
        .padding()
        .navigationTitle("future_estimations")
    }
}

struct FutureEstimationProviderView_Previews: PreviewProvider {
    static var previews: some View {
        FutureEstimationProviderView(futureEstimationProvider: FutureEstimationProvider(provider: MockData.countries[0], estimationInterval: 7, metric: .confirmed), manager: MockDataManager())
    }
}
