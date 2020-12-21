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
            Button("Calculate intersect") {
                showingProviderSelectionSheet = true
            }
            .buttonStyle(CustomButtonStyle())
        }
        .sheet(isPresented: $showingProviderSelectionSheet) {
            SummaryProviderSelectionView(isPresented: $showingProviderSelectionSheet, providers: manager.countries, provider: futureEstimationProvider.provider as! Country) { isPresented, provider -> FutureEstimationProviderCaseNumbersIntersectionView<Provider> in
                showingProviderSelectionSheet = isPresented.wrappedValue
                return FutureEstimationProviderCaseNumbersIntersectionView(provider1: futureEstimationProvider, provider2: FutureEstimationProvider(provider: provider as! Provider), isPresented: $showingProviderSelectionSheet)
            }
        }
        .padding()
        .navigationTitle("Future estimations")
    }
}

struct FutureEstimationProviderView_Previews: PreviewProvider {
    static var previews: some View {
        FutureEstimationProviderView(futureEstimationProvider: FutureEstimationProvider(provider: MockData.countries[0], estimationInterval: 7, metric: .confirmed), manager: MockDataManager())
    }
}
