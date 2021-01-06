//
//  SummaryProviderSquareView.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 28.11.20.
//

import SwiftUI

struct SummaryProviderSquareView<Provider: SummaryProvider>: View {
    let provider: Provider
    @Binding var metric: BasicMeasurementMetric
    @AppStorage(UserDefaultsKeys.colorTresholdForDeltas) var colorTresholdForDeltas = DefaultSettings.colorTresholdForDeltas
    @AppStorage(UserDefaultsKeys.colorGrayAreaForDeltas) var colorGrayAreaForDeltas = DefaultSettings.colorGrayAreaForDeltas
    var body: some View {
        VStack(alignment: .leading) {
            Text(provider.description.localizedCapitalized)
                .padding()
            Text(provider.value(for: metric, significantDigits: 3))
                .font(.title)
                .bold()
                .padding(.horizontal)
            provider.newSummaryElement(metric: metric, colorTresholdForDeltas: colorTresholdForDeltas, colorGrayAreaForDeltas: colorGrayAreaForDeltas)
                    .font(.subheadline)
                    .padding(.horizontal)
            Spacer()
        }
        .frame(width: 150, height: 150)
    }
}

struct SummaryProviderSquareView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryProviderSquareView(provider: MockData.countries[0], metric: .constant(.confirmed))
            .previewLayout(.sizeThatFits)
    }
}
