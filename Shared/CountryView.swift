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
                VStack {
                    ProgressView()
                    Text("Loading or so…")
                }
                .onAppear {
                    manager.loadData(for: country)
                    print("loading")
                }
            }
        }
        .navigationTitle(country.name.localizedCapitalized)
    }
}

extension CountryView: DataManagerHistorySubscriber {
    func didUpdateHistory(new countries: [Country]) {
        print("got \(countries.count) values")
//        history = countries.first(where: {$0.name == countryName})?.measurements
//        print("updated: \(history?.count ?? -1) values in total!")
    }
}

struct CountryView_Previews: PreviewProvider {
    static var previews: some View {
        CountryView(country: countriesForPreviews[0])
    }
}
