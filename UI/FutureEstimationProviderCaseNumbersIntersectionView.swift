//
//  FutureEstimationProviderCaseNumbersIntersectionView.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 20.12.20.
//

import SwiftUI

struct FutureEstimationProviderCaseNumbersIntersectionView<Provider: SummaryProvider>: View {
    let provider1: FutureEstimationProvider<Provider>
    let provider2: FutureEstimationProvider<Provider>
    @AppStorage(UserDefaultsKeys.measurementMetric) var metric = DefaultSettings.measurementMetric
    @Environment(\.presentationMode) var presentationMode
    @State private var intersection: FutureEstimationProvider<Provider>.IntersectionPoint?
    @Binding var isPresented: Bool
    var body: some View {
        VStack {
            BasicMeasurementMetricPickerView(activeMetric: $metric)
                .onChange(of: metric) {_ in
                    calculateIntersection()
                }
            Text("Based on current rates, \(provider1.provider.description.localizedCapitalized) and \(provider2.provider.description.localizedCapitalized) will have the same \(metric.humanReadable.lowercased()) in \(intersection?.t.daysHumanReadable ?? Constants.notAvailableString) days, making it \(intersection?.y.daysHumanReadable ?? Constants.notAvailableString) \(metric.shortDescription.lowercased()).")
                .onAppear(perform: calculateIntersection)
            Spacer()
        }
        .padding()
        .navigationTitle("Case intersect")
        .navigationBarItems(trailing: Button("Done"){
            isPresented = false
        })
    }
    
    func calculateIntersection() {
        provider1.metric = metric
        provider2.metric = metric
        intersection = provider1.intersection(with: provider2)
    }
}

struct FutureEstimationProviderCaseNumbersIntersectionView_Previews: PreviewProvider {
    static var previews: some View {
        FutureEstimationProviderCaseNumbersIntersectionView<Country>(provider1: MockData.futureEstimationProvider, provider2: MockData.futureEstimationProvider, isPresented: .constant(true))
    }
}
