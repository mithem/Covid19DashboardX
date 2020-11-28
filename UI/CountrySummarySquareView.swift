//
//  CountrySummarySquareView.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 28.11.20.
//

import SwiftUI

struct CountrySummarySquareView: View {
    let country: Country
    @AppStorage(UserDefaultsKeys.colorThresholdForPercentages) var colorTreshold = DefaultSettings.colorTresholdForPercentages
    @AppStorage(UserDefaultsKeys.colorGrayAreaForPercentages) var colorGrayArea = DefaultSettings.colorGrayAreaForPercentages
    var body: some View {
        VStack(alignment: .leading) {
            Text(country.name.localizedCapitalized)
                .padding()
            Text(country.newConfirmed.humanReadable)
                .font(.title)
                .bold()
                .padding(.horizontal)
                country.newSummaryElement(total: country.totalConfirmed, new: country.newConfirmed, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea)
                    .font(.subheadline)
                    .padding(.horizontal)
            Spacer()
        }
        .frame(width: 150, height: 150)
    }
}

struct CountrySummarySquareView_Previews: PreviewProvider {
    static var previews: some View {
        CountrySummarySquareView(country: MockData.countries[0])
            .previewLayout(.sizeThatFits)
    }
}
