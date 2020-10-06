//
//  CountryView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 04.10.20.
//

import SwiftUI
import SwiftUICharts

struct CountryView: View {
    @EnvironmentObject var manager: DataManager
    let country: Country
    var body: some View {
        Group {
            if country.measurements.count > 0 {
                LineView(data: country.measurements.map {Double($0.confirmed)}, title: "Confirmed cases")
                    .padding()
            } else {
                VStack(spacing: 10) {
                    ProgressView()
                    Text("Loading…")
                }
                .onAppear {
                    manager.loadData(for: country)
                }
            }
        }
        .navigationTitle(country.name.localizedCapitalized)
    }
}

struct CountryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                CountryView(country: countriesForPreviews[0])
            }
            .previewDisplayName("Success")
            NavigationView {
                CountryView(country: SpecialCountries.emptyCountry)
                    .environmentObject(DataManager())
            }
            .previewDisplayName("No internet")
        }
    }
}
